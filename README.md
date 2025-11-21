# Infrastructure Deployment Guide (AWS + Terraform + EKS + Jenkins + Argo CD)

Цей проєкт містить повний пайплайн інфраструктури на AWS з використанням
Terraform, EKS, RDS, ECR, Jenkins, Argo CD, Prometheus та Grafana.

------------------------------------------------------------------------

## 📁 Структура проєкту

    Project/
    │
    ├── main.tf
    ├── backend.tf
    ├── outputs.tf
    │
    ├── modules/
    │  ├── s3-backend/
    │  ├── vpc/
    │  ├── ecr/
    │  ├── eks/
    │  ├── rds/
    │  ├── jenkins/
    │  └── argo_cd/
    │
    ├── charts/
    │  └── django-app/
    │
    └── Django/

------------------------------------------------------------------------

## 🚀 1. Підготовка середовища

### Встановіть необхідні інструменти:

-   Terraform ≥ 1.6
-   AWS CLI
-   kubectl
-   Helm
-   Docker
-   Git

### Створіть bucket і DynamoDB таблицю

    aws s3api create-bucket \
        --bucket demo-platform-tf-state \
        --region eu-central-1 \
        --create-bucket-configuration LocationConstraint=eu-central-1

    aws dynamodb create-table \
        --table-name demo-platform-tf-lock \
        --attribute-definitions AttributeName=LockID,AttributeType=S \
        --key-schema AttributeName=LockID,KeyType=HASH \
        --billing-mode PAY_PER_REQUEST

### Ініціалізуйте Terraform

Спочатку коментуємо конфіг в backend.tf, потім:

    terraform init

Далі - розкоментуємо конфіг в backend.tf і

    terraform init -migrate-state

### Перевірте змінні

У файлах `variables.tf` перевірте: - регіон - імена бакетів - креденшели
БД - назви кластерів

------------------------------------------------------------------------

## 🏗️ 2. Розгортання інфраструктури

Запустіть команду:

    terraform apply

Після створення EKS кластеру виконайте:

    aws eks update-kubeconfig --region <your-region> --name <cluster-name>

Перевірте, що неймспейси Jenkins, ArgoCD, Monitoring створені:

    kubectl get all -n jenkins
    kubectl get all -n argocd
    kubectl get all -n monitoring

------------------------------------------------------------------------

## 🔐 3. Перевірка доступності сервісів

### Jenkins:

    kubectl port-forward svc/jenkins 8080:8080 -n jenkins

Відкрий у браузері: http://localhost:8080

------------------------------------------------------------------------

### Argo CD:

    kubectl port-forward svc/argocd-server 8081:443 -n argocd

Відкрий: http://localhost:8081

------------------------------------------------------------------------

### Grafana:

    kubectl port-forward svc/grafana 3000:80 -n monitoring

Відкрий: http://localhost:3000

------------------------------------------------------------------------

## 📊 4. Перевірка моніторингу

Переконайся, що: - Prometheus збирає метрики - Grafana показує
Dashboard'и - kube‑state‑metrics і node‑exporter працюють

    kubectl get pods -n monitoring

------------------------------------------------------------------------

## ⚠️ ВАЖЛИВО: Видалення інфраструктури

Щоб уникнути зайвих витрат у AWS:

    terraform destroy

⚠️ Пам'ятай: команда також видаляє **S3 bucket та DynamoDB таблицю**
бекенду Terraform.\
Якщо плануєш повторний запуск --- потрібно буде знову створити ці
ресурси.

------------------------------------------------------------------------

## 📘 5. Порядок перезапуску інфраструктури

1.  Створити S3 + DynamoDB (модуль `s3-backend`)
2.  Увімкнути backend у `backend.tf`
3.  `terraform init -migrate-state`
4.  `terraform apply`
5.  Оновити kubeconfig
6.  Перевірити розгортання

------------------------------------------------------------------------

## 🐍 6. CI/CD

### Jenkins

Додає: - збірку Docker образу - пуш у ECR - тригер оновлення у Argo CD

### Argo CD

Синхронізує Helm-чарти: - django-app - monitoring stack - інші сервіси

------------------------------------------------------------------------

## 📦 7. Django App

Має Dockerfile, Jenkinsfile, Helm-чарт із: - Deployment - Service -
ConfigMap - HPA
