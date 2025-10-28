variable "vpc_cidr_block" {
  type        = string
  description = "CIDR of the VPC, z.B. 10.0.0.0/16"
}

variable "public_subnets" {
  type        = list(string)
  description = "List of the Public Subnet CIDRs (3)"
}

variable "private_subnets" {
  type        = list(string)
  description = "List of the Private Subnet CIDRs (3)"
}

variable "availability_zones" {
  type        = list(string)
  description = "AZs, f.e. [\"eu-central-1a\",\"eu-central-1b\",\"eu-central-1c\"]"
}

variable "vpc_name" {
  type        = string
  description = "Name-Tag of the VPC"
}
