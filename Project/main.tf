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
}

# VPC Module
module "vpc" {
  source = "./modules/vpc"
  
  vpc_cidr = var.vpc_cidr
  environment = var.environment
}

# ECR Module
module "ecr" {
  source = "./modules/ecr"
  
  repository_name = var.ecr_repository_name
  environment = var.environment
}

# EKS Module
module "eks" {
  source = "./modules/eks"
  
  cluster_name = var.cluster_name
  vpc_id = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  public_subnets = module.vpc.public_subnets
  environment = var.environment
}

# Jenkins Module
module "jenkins" {
  source = "./modules/jenkins"
  
  depends_on = [module.eks]
  
  cluster_name = module.eks.cluster_name
  cluster_endpoint = module.eks.cluster_endpoint
  cluster_ca_certificate = module.eks.cluster_ca_certificate
  cluster_token = module.eks.cluster_token
  environment = var.environment
}

# Argo CD Module
module "argo_cd" {
  source = "./modules/argo_cd"
  
  depends_on = [module.eks]
  
  cluster_name = module.eks.cluster_name
  cluster_endpoint = module.eks.cluster_endpoint
  cluster_ca_certificate = module.eks.cluster_ca_certificate
  cluster_token = module.eks.cluster_token
  environment = var.environment
} 