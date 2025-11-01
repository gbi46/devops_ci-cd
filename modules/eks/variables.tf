variable "cluster_name" {
  type        = string
  description = "EKS cluster name"
  default     = "lesson-7-eks"
}

variable "cluster_version" {
  type        = string
  description = "Kubernetes version for EKS"
  default     = "1.30"
}

variable "vpc_id" {
  type        = string
  description = "VPC where EKS will be created"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnets for EKS worker nodes"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "Public subnets (optionally) for load balancers"
  default     = []
}

variable "node_group_desired_size" {
  type    = number
  default = 2
}

variable "node_group_min_size" {
  type    = number
  default = 2
}

variable "node_group_max_size" {
  type    = number
  default = 4
}

variable "instance_types" {
  type    = list(string)
  default = ["t3.medium"]
}

variable "tags" {
  type    = map(string)
  default = {}
}
