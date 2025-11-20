# Demo: Terraform + EKS + Jenkins + Argo CD + Helm + GitOps

Цей репозиторій демонструє повний GitOps-ланцюжок:\
**Terraform** ➜ **AWS (VPC, EKS, ECR)** ➜ **Jenkins (CI)** ➜ **Argo CD +
Helm (CD)**.

------------------------------------------------------------------------

## 1. Передумови

-   AWS акаунт, налаштований через `aws configure`
-   Встановлені:
    -   `terraform` (версія ≥ 1.5)
    -   `kubectl`
    -   `helm`
-   GitHub/GitLab репозиторії:
    -   **env-repo** -- репозиторій із Helm-чартом `charts/django-app`,
        який відстежує Argo CD

------------------------------------------------------------------------

## 2. Порядок запуску інфраструктури

> **Примітка:** S3 та DynamoDB використовуються як бекенд для Terraform
> стейту.\
> При повному `terraform destroy` вони також будуть видалені.

### 2.1. Ініціалізація локально (без бекенду S3)

Тимчасово закоментуйте блок:

``` hcl
backend "s3" {
  ...
}
```

у файлі `backend.tf`, а потім виконайте:

``` bash
terraform init
terraform apply -target=module.s3_backend
```

Це створить S3-бакет і DynamoDB-таблицю для бекенду Terraform.

------------------------------------------------------------------------

### 2.2. Увімкнути бекенд S3

Після створення бакета та таблиці --- **розкоментуйте** блок
`backend "s3"` у `backend.tf` і виконайте міграцію стейту:

``` bash
terraform init -migrate-state
```

------------------------------------------------------------------------

### 2.3. Створення всієї інфраструктури

Запустіть:

``` bash
terraform apply
```

Це створить:

-   VPC + підмережі\
-   EKS кластер\
-   ECR репозиторій\
-   Jenkins (через Helm)\
-   Argo CD (через Helm)\
-   Argo CD Application, що стежить за `charts/django-app` з
    **env-repo**

------------------------------------------------------------------------

## 3. Налаштування Jenkins

### 3.1. Дізнатись URL сервісу Jenkins

``` bash
kubectl get svc -n jenkins
```

Для доступу ззовні:

-   або змінити тип сервісу на `LoadBalancer`,
-   або використати `port-forward`:

``` bash
kubectl port-forward svc/jenkins 8080:8080 -n jenkins
```

### 3.2. Логін у Jenkins

Якщо не змінювали `values.yaml`:

    user: admin
    password: admin123

Створіть Pipeline або Multibranch Pipeline й вкажіть репозиторій з
Jenkinsfile.

------------------------------------------------------------------------

## 4. Як перевірити Jenkins job

Після запуску job у логах мають бути:

-   Build & Push Image with Kaniko\
-   Update Helm values in env repo

### 4.1. Перевірка env-repo

Переконайтесь, що у файлі:

    charts/django-app/values.yaml

тег оновився на актуальний `GIT_COMMIT`.

### 4.2. Перевірка ECR

``` bash
aws ecr list-images --repository-name django-app
```

------------------------------------------------------------------------

## 5. Як побачити результат в Argo CD

### 5.1. Отримати URL

``` bash
kubectl get svc -n argocd
```

При ClusterIP:

``` bash
kubectl port-forward svc/argo-cd-argocd-server -n argocd 8081:80
```

Argo CD буде доступний на:\
http://localhost:8081

### 5.2. Логін

``` bash
kubectl -n argocd get secret argocd-initial-admin-secret   -o jsonpath="{.data.password}" | base64 -d
```

### 5.3. Перевірка Application

-   OutOfSync після комміту\
-   Synced після автосинхронізації

### 5.4. Перевірка деплою

``` bash
kubectl get pods -n django
kubectl get svc -n django
```

------------------------------------------------------------------------

## 6. Видалення

``` bash
terraform destroy
```
