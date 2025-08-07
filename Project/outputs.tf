# S3 Backend outputs
output "s3_bucket_id" {
  description = "The name of the S3 bucket"
  value       = module.s3_backend.bucket_id
}

output "s3_bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = module.s3_backend.bucket_arn
}

output "dynamodb_table_id" {
  description = "The name of the DynamoDB table"
  value       = module.s3_backend.table_id
}

output "dynamodb_table_arn" {
  description = "The ARN of the DynamoDB table"
  value       = module.s3_backend.table_arn
}

# VPC outputs
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

output "public_subnet_ids" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnet_ids
}

# ECR outputs
output "ecr_repository_url" {
  description = "The URL of the ECR repository"
  value       = module.ecr.repository_url
}

output "ecr_repository_arn" {
  description = "The ARN of the ECR repository"
  value       = module.ecr.repository_arn
}

# EKS outputs
output "eks_cluster_id" {
  description = "The ID of the EKS cluster"
  value       = module.eks.cluster_id
}

output "eks_cluster_arn" {
  description = "The ARN of the EKS cluster"
  value       = module.eks.cluster_arn
}

output "eks_cluster_endpoint" {
  description = "The endpoint for the EKS cluster"
  value       = module.eks.cluster_endpoint
}

# RDS outputs
output "database_type" {
  description = "The type of database created (Aurora or RDS)"
  value       = module.rds.database_type
}

output "database_engine" {
  description = "The database engine used"
  value       = module.rds.engine
}

output "database_engine_version" {
  description = "The database engine version used"
  value       = module.rds.engine_version
}

# RDS Instance outputs (when use_aurora = false)
output "rds_instance_id" {
  description = "The ID of the RDS instance"
  value       = module.rds.rds_instance_id
}

output "rds_instance_endpoint" {
  description = "The connection endpoint of the RDS instance"
  value       = module.rds.rds_instance_endpoint
}

output "rds_instance_address" {
  description = "The address of the RDS instance"
  value       = module.rds.rds_instance_address
}

# Aurora Cluster outputs (when use_aurora = true)
output "aurora_cluster_id" {
  description = "The ID of the Aurora cluster"
  value       = module.rds.aurora_cluster_id
}

output "aurora_cluster_endpoint" {
  description = "The cluster endpoint of the Aurora cluster"
  value       = module.rds.aurora_cluster_endpoint
}

output "aurora_cluster_reader_endpoint" {
  description = "The cluster reader endpoint of the Aurora cluster"
  value       = module.rds.aurora_cluster_reader_endpoint
}

output "aurora_instance_ids" {
  description = "The IDs of the Aurora cluster instances"
  value       = module.rds.aurora_instance_ids
}

# Shared RDS outputs
output "db_subnet_group_id" {
  description = "The ID of the DB subnet group"
  value       = module.rds.db_subnet_group_id
}

output "db_security_group_id" {
  description = "The ID of the security group"
  value       = module.rds.security_group_id
}

output "db_parameter_group_id" {
  description = "The ID of the parameter group"
  value       = module.rds.parameter_group_id
}

# Jenkins outputs
output "jenkins_url" {
  description = "The URL of the Jenkins server"
  value       = module.jenkins.jenkins_url
}

output "jenkins_admin_password" {
  description = "The admin password for Jenkins"
  value       = module.jenkins.jenkins_admin_password
  sensitive   = true
}

# Argo CD outputs
output "argocd_url" {
  description = "The URL of the Argo CD server"
  value       = module.argo_cd.argocd_url
}

output "argocd_admin_password" {
  description = "The admin password for Argo CD"
  value       = module.argo_cd.argocd_admin_password
  sensitive   = true
} 