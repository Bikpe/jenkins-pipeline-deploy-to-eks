# variable "vpc_cidr_block" {}
# variable "private_subnet_cidr_blocks" {}
# variable "public_subnet_cidr_blocks" {}



# variable "environment" {
#   description = "The environment name (e.g., staging, prod)"
#   type        = string
# }

# variable "cluster_name" {
#   description = "Name for the EKS cluster"
#   type        = string
# }

# variable "vpc_cidr" {
#   description = "CIDR block for the EKS VPC"
#   type        = string
#   default     = "10.100.0.0/16"
# }

# variable "instance_type" {
#   description = "EC2 instance type for the EKS worker nodes"
#   type        = string
#   default     = "t3.medium"
# }

# variable "desired_size" {
#   description = "Desired number of worker nodes"
#   type        = number
#   default     = 2
# }

# variable "max_size" {
#   description = "Maximum number of worker nodes"
#   type        = number
#   default     = 4
# }


variable "environment" {
  description = "The environment name (e.g., staging, prod)"
  type        = string
}

variable "cluster_name" {
  description = "Name for the EKS cluster"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the EKS VPC"
  type        = string
  default     = "10.100.0.0/16"
}

variable "instance_type" {
  description = "EC2 instance type for the EKS worker nodes"
  type        = string
  default     = "t2.small"
}

variable "desired_size" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 4
}

variable "region" {
  description = "The AWS region to deploy EKS"
  type        = string
  default     = "us-east-1"
}