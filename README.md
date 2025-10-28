# Lesson-5: Terraform AWS Infrastructure Project  
*(S3 + DynamoDB backend, VPC, and ECR modules)*

---

## 📁 Project Structure

lesson-5/
│
├── main.tf # Main Terraform configuration file — connects all modules
├── backend.tf # Backend configuration for remote state storage (S3 + DynamoDB)
├── outputs.tf # Global outputs that expose key resource information
│
├── modules/ # Directory containing all reusable Terraform modules
│ │
│ ├── s3-backend/ # Module for remote backend resources
│ │ ├── s3.tf # Creates the S3 bucket for Terraform state
│ │ ├── dynamodb.tf # Creates the DynamoDB table for state locking
│ │ ├── variables.tf # Input variables for the S3 and DynamoDB module
│ │ └── outputs.tf # Outputs bucket and table details
│ │
│ ├── vpc/ # Module for Virtual Private Cloud (VPC)
│ │ ├── vpc.tf # Creates VPC, subnets, and Internet Gateway
│ │ ├── routes.tf # Configures routing tables and NAT gateways
│ │ ├── variables.tf # Input variables for network configuration
│ │ └── outputs.tf # Outputs VPC ID and subnet information
│ │
│ └── ecr/ # Module for Elastic Container Registry (ECR)
│ ├── ecr.tf # Creates the ECR repository
│ ├── variables.tf # Input variables for the ECR module
│ └── outputs.tf # Outputs the ECR repository URL
│
└── README.md # Project documentation (this file)

---

## 🎯 **Project Goals**

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

## ⚙️ **Setup Instructions**

### Step 1 — Initialize the project locally
First, work with a **local backend** until your S3 and DynamoDB are created.

```bash
terraform init
terraform plan
terraform apply
terraform destroy
