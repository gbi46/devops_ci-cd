# Terraform AWS Infrastructure Project
*(S3 + DynamoDB backend, VPC, and ECR modules)*

## 📁 Project Structure

```
    ├── app
    │   ├── Dockerfile
    │   └── requirements.txt
    ├── infrastructure
    │   ├── charts
    │   │   └── django-app
    │   │       ├── templates
    │   │       │   ├── _helpers.tpl
    │   │       │   ├── configmap.yaml
    │   │       │   ├── deployment.yaml
    │   │       │   ├── hpa.yaml
    │   │       │   └── service.yaml
    │   │       ├── Chart.yaml
    │   │       └── values.yaml
    │   ├── modules
    │   │   ├── ecr
    │   │   │   ├── ecr.tf
    │   │   │   ├── outputs.tf
    │   │   │   └── variables.tf
    │   │   ├── eks
    │   │   │   ├── eks.tf
    │   │   │   ├── outputs.tf
    │   │   │   └── variables.tf
    │   │   ├── s3-backend
    │   │   │   ├── dynamodb.tf
    │   │   │   ├── outputs.tf
    │   │   │   ├── s3.tf
    │   │   │   └── variables.tf
    │   │   └── vpc
    │   │       ├── outputs.tf
    │   │       ├── routes.tf
    │   │       ├── variables.tf
    │   │       └── vpc.tf
    │   ├── .gitignore
    │   ├── backend.tf
    │   ├── eks-create.json
    │   ├── main.tf
    │   └── outputs.tf
    └── README.md
```

### Requirements

- Terraform >= 1.0
- Providers: aws
- Valid credentials

**Backend:** s3

**Modules:** ./modules/ecr, ./modules/eks, ./modules/s3-backend, ./modules/vpc

## Requirements

- Terraform >= 1.0
- Credentials configured for your cloud provider (e.g., AWS via environment variables or config file)

---

## 🎯 Project Goals

This Terraform project automates the deployment and configuration of a scalable infrastructure for a Django application using modern AWS and Kubernetes tools. It includes:

1. **Kubernetes Cluster Provisioning**

   - Automated creation of an Amazon EKS (Elastic Kubernetes Service) cluster using Terraform

   - Configuration of node groups, networking, and IAM roles for seamless integration

2. **Elastic Container Registry (ECR) Setup**

   - Secure AWS ECR repository for storing Docker images of the Django application

   - Image scanning enabled to ensure container security

3. **Docker Image Management**

   - Building and pushing the Django Docker image to the ECR repository

   - Versioned image tagging for consistent deployment updates

4. **Helm Chart Deployment**

   - Custom Helm chart for managing application deployment

   - Includes key Kubernetes manifests:

      - deployment.yaml — Pod and ReplicaSet configuration

      - service.yaml — Service exposure and networking

      - hpa.yaml — Horizontal Pod Autoscaler setup for scaling

      - configmap.yaml — Application configuration management

## Getting Started

This is a **Terraform** project for provisioning infrastructure.

### Quick Start

```bash
cd infrastructure/modules/s3-backend
terraform init
terraform plan
terraform apply
```

### Run app with infrastructure

```bash
aws sts get-caller-identity
aws configure get region
aws eks update-kubeconfig --name <cluster> --region <region>
kubectl config current-context
```
