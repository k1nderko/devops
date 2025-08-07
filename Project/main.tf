terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# S3 Backend Module
module "s3_backend" {
  source = "./modules/s3-backend"
  bucket_name = var.s3_bucket_name
  table_name  = var.dynamodb_table_name
  tags = {
    Environment = var.environment
    Project     = "final-project"
    Module      = "s3-backend"
  }
}

# VPC Module
module "vpc" {
  source = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
  environment = var.environment
  aws_region = var.aws_region
  tags = {
    Environment = var.environment
    Project     = "final-project"
    Module      = "vpc"
  }
}

# ECR Module
module "ecr" {
  source = "./modules/ecr"
  repository_name = var.ecr_repository_name
  environment = var.environment
  tags = {
    Environment = var.environment
    Project     = "final-project"
    Module      = "ecr"
  }
}

# EKS Module
module "eks" {
  source = "./modules/eks"
  cluster_name = var.eks_cluster_name
  environment = var.environment
  vpc_id = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  public_subnet_ids = module.vpc.public_subnet_ids
  tags = {
    Environment = var.environment
    Project     = "final-project"
    Module      = "eks"
  }
}

# RDS Module
module "rds" {
  source = "./modules/rds"

  # Basic configuration
  identifier = "${var.environment}-database"
  use_aurora = var.use_aurora

  # Engine configuration
  engine = var.db_engine
  engine_version = var.db_engine_version
  instance_class = var.db_instance_class

  # Network configuration
  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids
  vpc_cidr_blocks = [module.vpc.vpc_cidr_block]

  # Credentials
  username = var.db_username
  password = var.db_password

  # Aurora specific
  aurora_cluster_instances = var.aurora_cluster_instances
  aurora_instance_class = var.aurora_instance_class

  # Tags
  tags = {
    Environment = var.environment
    Project     = "final-project"
    Module      = "rds"
  }
}

# Jenkins Module
module "jenkins" {
  source = "./modules/jenkins"
  depends_on = [module.eks]
  
  cluster_endpoint = module.eks.cluster_endpoint
  cluster_certificate_authority_data = module.eks.cluster_certificate_authority_data
  cluster_token = data.aws_eks_cluster_auth.cluster.token
}

# Argo CD Module
module "argo_cd" {
  source = "./modules/argo_cd"
  depends_on = [module.eks]
  
  cluster_endpoint = module.eks.cluster_endpoint
  cluster_certificate_authority_data = module.eks.cluster_certificate_authority_data
  cluster_token = data.aws_eks_cluster_auth.cluster.token
}

# Monitoring Module (Prometheus + Grafana)
module "monitoring" {
  source = "./modules/monitoring"
  depends_on = [module.eks]
  
  cluster_endpoint = module.eks.cluster_endpoint
  cluster_certificate_authority_data = module.eks.cluster_certificate_authority_data
  cluster_token = data.aws_eks_cluster_auth.cluster.token
}

# Data source for EKS cluster auth
data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
} 