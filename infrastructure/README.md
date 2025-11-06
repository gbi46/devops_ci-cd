# Lesson 5: Terraform AWS Infrastructure Project  
*(S3 + DynamoDB backend, VPC, and ECR modules)*


## 📁 Project Structure

```text
├── main.tf # Main Terraform configuration file — connects all modules
├── backend.tf # Backend configuration for remote state storage (S3 + DynamoDB)
├── outputs.tf # Global outputs that expose key resource information
│
├── modules/                        # Directory containing all reusable Terraform modules
│
│  ├── ecr/                         # Module for Elastic Container Registry (ECR)
│  │  ├── ecr.tf                    # Creates the ECR repository
│  │  ├── variables.tf              # Input variables for the ECR module
│  │  └── outputs.tf                # Outputs the ECR repository URL
│
│  ├── s3-backend/                  # Module for remote backend resources (Terraform state)
│  │  ├── s3.tf                     # Creates the S3 bucket
│  │  ├── dynamodb.tf               # Creates the DynamoDB lock table
│  │  ├── variables.tf              # Input variables for the backend module
│  │  └── outputs.tf                # Outputs bucket & table names
│
│  ├── vpc/                         # Module for Virtual Private Cloud (VPC)
│  │  ├── vpc.tf                    # Creates VPC and subnets
│  │  ├── routes.tf                 # Routing rules and gateways
│  │  ├── variables.tf              # Variables for network configuration
│  │  └── outputs.tf                # Outputs VPC ID and subnet lists
│
│  └── eks/                         # Module for Elastic Kubernetes Service (EKS)
│     ├── eks.tf                    # Creates EKS cluster & worker node groups
│     ├── variables.tf              # Input variables for the EKS module (cluster name, subnets, node settings)
│     └── outputs.tf                # Outputs kubeconfig data, cluster endpoint, CA cert, and node group name

│
└── README.md # Project documentation (this file)
```

---

## 🎯 Project Goals

This Terraform project sets up:

1. **Remote state backend**
   - S3 bucket for storing Terraform state files  
   - DynamoDB table for state locking  

2. **Network infrastructure (VPC)**
   - Custom VPC with 3 public and 3 private subnets  
   - Internet Gateway (for public subnets)  
   - NAT Gateway (for private subnets)  
   - Route tables for proper routing  

3. **ECR (Elastic Container Registry)**
   - Secure repository for Docker images  
   - Automatic image scanning on push  

---

## ⚙️ Setup Instructions

### Step 1 — Initialize the project locally
Start with a **local backend** until the S3 bucket and DynamoDB table are created:

```bash
terraform init
terraform plan
terraform apply
terraform destroy
```