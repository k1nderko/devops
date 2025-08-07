# Global variables
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

# S3 Backend variables
variable "s3_bucket_name" {
  description = "Name of the S3 bucket for Terraform state"
  type        = string
  default     = "devops-terraform-state-bucket"
}

variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table for Terraform state locking"
  type        = string
  default     = "terraform-state-lock"
}

# VPC variables
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# ECR variables
variable "ecr_repository_name" {
  description = "Name of the ECR repository"
  type        = string
  default     = "django-app"
}

# EKS variables
variable "eks_cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "devops-cluster"
}

# RDS variables
variable "use_aurora" {
  description = "Whether to create Aurora Cluster (true) or regular RDS instance (false)"
  type        = bool
  default     = false
}

variable "db_engine" {
  description = "The database engine to use"
  type        = string
  default     = "postgres"
  validation {
    condition     = contains(["postgres", "mysql", "mariadb", "aurora-postgresql", "aurora-mysql"], var.db_engine)
    error_message = "Engine must be one of: postgres, mysql, mariadb, aurora-postgresql, aurora-mysql."
  }
}

variable "db_engine_version" {
  description = "The engine version to use"
  type        = string
  default     = "14.9"
}

variable "db_instance_class" {
  description = "The instance type of the RDS instance"
  type        = string
  default     = "db.t3.micro"
}

variable "db_username" {
  description = "Username for the master DB user"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Password for the master DB user"
  type        = string
  sensitive   = true
}

variable "aurora_cluster_instances" {
  description = "Number of Aurora cluster instances"
  type        = number
  default     = 1
}

variable "aurora_instance_class" {
  description = "The instance type of the Aurora cluster instances"
  type        = string
  default     = "db.r5.large"
} 