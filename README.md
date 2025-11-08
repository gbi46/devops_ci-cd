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

1. **Kubernetes cluster is created via Terraform and running**

```bash
# Cluster exists and ACTIVE
aws eks describe-cluster --name <cluster> --region <region> \
  --query 'cluster.status' --output text

# Nodes are Ready
kubectl get nodes -o wide

# Core namespaces healthy
kubectl get ns
kubectl get pods -A --field-selector=status.phase!=Running,status.phase!=Succeeded
```

2. **ECR exists and contains Django image**

```bash
aws ecr describe-repositories --repository-names <repo> --region <region> \
  --query 'repositories[0].repositoryUri' --output text

aws ecr list-images --repository-name <repo> --region <region> \
  --query 'imageIds[*].imageTag' --output text
```

3. **Deployment, Service, HPA are installed and working (via Helm)**

```bash
helm list -n <namespace>
helm status <release> -n <namespace>
kubectl get deploy,rs,po,svc,hpa -n <namespace>
kubectl rollout status deploy/<release>-app -n <namespace> --timeout=120s
# If different names, adjust: `kubectl get deploy -n <namespace>` to see exact name
kubectl get hpa -n <namespace>
kubectl describe hpa <release>-hpa -n <namespace>   # check metrics target/source
```

4. **ConfigMap is created and used by the app**
kubectl get configmap -n <namespace>
kubectl describe configmap <release>-config -n <namespace>    # adjust name
kubectl get deploy <deploy_name> -n <namespace> -o yaml | \
  yq '.spec.template.spec | {envFrom: .containers[0].envFrom, volumes, volumeMounts: .containers[0].volumeMounts}'
