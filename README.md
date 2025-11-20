# Demo: Terraform + EKS + Jenkins + Argo CD + Helm + GitOps

## 1. Передумови

- AWS акаунт, налаштований `aws configure`
- Terraform >= 1.5
- kubectl, helm
- GitHub/GitLab репозиторії:
  - **env-repo** – з Helm-чартом `charts/django-app`, який дивиться Argo CD

## 2. Порядок запуску інфраструктури

> S3 та DynamoDB використовуються як бекенд для Terraform стейту. При повному `terraform destroy` вони теж будуть видалені.

1. **Ініціалізація локально (без бекенду S3)**  
   Тимчасово закоментуйте `backend "s3"` у `backend.tf` і запустіть:

   ```bash
   terraform init
   terraform apply -target=module.s3_backend

2. **Увімкнути бекенд S3**
   Після створення бакета та таблиці – розкоментуйте backend "s3" у backend.tf,
   виконайте:

   ```bash
   terraform init -migrate-state

3. **Створення всієї інфраструктури**

   ```bash
   terraform apply

   Це створить:

    - VPC + підмережі

    - EKS кластер

    - ECR репозиторій

    - Jenkins (через Helm)

    - Argo CD (через Helm)

    - Argo CD Application, що стежить за charts/django-app з env-repo

4. **Налаштування jenkins**

   Дізнатися URL (внутрішній сервіс)

   ```bash
   kubectl get svc -n jenkins

Для доступу ззовні:

   - або змінити тип сервісу на LoadBalancer,

   - або зробити 
      
   ```bash
      kubectl port-forward svc/jenkins 8080:8080 -n jenkins


Залогінитись (якщо не міняв values.yaml):

user: admin

password: admin123

Створити Pipeline job (або Multibranch) і вказати репозиторій з Jenkinsfile.

5. **Як перевірити Jenkins job**

Запустити job.

У логах побачиш:

- стадію Build & Push Image with Kaniko з пушем в ECR

- стадію Update Helm values in env repo – комміт в env-repo.

Перевір, що в env-repo:

файл charts/django-app/values.yaml має оновлений .image.tag на GIT_COMMIT.

Переконайся, що імідж є в ECR:

   aws ecr list-images --repository-name django-app

6. **Як побачити результат в Argo CD**

Отримати URL Argo CD server:

   kubectl get svc -n argocd


Якщо сервер типу LoadBalancer – бери external IP. Якщо ClusterIP – port-forward:

   kubectl port-forward svc/argo-cd-argocd-server -n argocd 8081:80

Відкрий http://localhost:8081

Логін (дефолт, якщо не міняв):

user: admin

пароль: з secret

   kubectl -n argocd get secret argocd-initial-admin-secret \
   -o jsonpath="{.data.password}" | base64 -d


В Argo CD має бути Application django-app.
Статус:

OutOfSync одразу після комміту.

Має перейти в Synced після автосинхронізації.

Перевір деплой у кластері:

   kubectl get pods -n django
   kubectl get svc -n django

6. **Видалення ресурсів**

Щоб уникнути зайвих витрат у хмарі:

   terraform destroy
