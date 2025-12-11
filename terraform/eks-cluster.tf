# module "eks" {
#     source  = "terraform-aws-modules/eks/aws"
#     version = "~> 19.0"
#     cluster_name = "myapp-eks-cluster"
#     cluster_version = "1.24"

#     cluster_endpoint_public_access  = true

#     vpc_id = module.myapp-vpc.vpc_id
#     subnet_ids = module.myapp-vpc.private_subnets

#     tags = {
#         environment = "development"
#         application = "myapp"
#     }

#     eks_managed_node_groups = {
#         dev = {
#             min_size = 1
#             max_size = 3
#             desired_size = 2

#             instance_types = ["t2.small"]
#         }
#     }
# }

# --- Provider Configuration ---

provider "aws" {
  region = "us-east-1" # Hardcoded region for simplicity, but can be a variable
}

# --- Module: EKS Cluster ---
# This community module handles the VPC, Subnets, Security Groups, and IAM roles for EKS.
module "eks_cluster" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0" # Use a stable version

  # Cluster Naming and Region
  cluster_name    = var.cluster_name
  cluster_version = "1.28"
#   region          = var.region

  # --- VPC Configuration (Creating a new VPC for the cluster) ---
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnets # EKS uses public/private subnets; for simplicity, using public here.

  # --- EKS Control Plane Configuration ---
  # Granting the 'jenkins' IAM user/role access (if using IAM roles for Jenkins)
  # For manual execution, this allows the user who ran `terraform apply` to access the cluster.
  # Replace "arn:aws:iam::123456789012:user/jenkins" with the actual ARN
#   manage_aws_auth_configmap = true
#   aws_auth_roles = [
#     {
#       rolearn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/jenkins" # Placeholder for Jenkins IAM user/role
#       username = "jenkins"
#       groups   = ["system:masters"]
#     },
#   ]

  # --- Default Managed Node Group ---
  eks_managed_node_groups = {
    default = {
      instance_types = [var.instance_type]
      min_size       = 1
      desired_size   = var.desired_size
      max_size       = var.max_size
      
      # Labels are useful for scheduling
      labels = {
        role = "general"
      }
    }
  }
}

# --- Module: VPC (Dedicated VPC for EKS) ---
# Creates the VPC and necessary subnets for the EKS cluster to reside in.
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0" # Use a stable version

  name = "${var.environment}-eks-vpc"
  cidr = var.vpc_cidr

  azs                 = ["${var.region}a", "${var.region}b", "${var.region}c"]
  public_subnets      = ["10.100.1.0/24", "10.100.2.0/24", "10.100.3.0/24"]
  enable_nat_gateway  = false # Can be set to true if nodes need to reach external services
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.environment}-eks-vpc"
    Environment = var.environment
  }
}

# --- Data Source: AWS Account ID ---
data "aws_caller_identity" "current" {}