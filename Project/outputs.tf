# S3 Backend outputs
output "s3_bucket_name" {
  description = "Name of the S3 bucket"
  value       = module.s3_backend.bucket_name
}

output "dynamodb_table_name" {
  description = "Name of the DynamoDB table"
  value       = module.s3_backend.table_name
}

# VPC outputs
output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "private_subnets" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnets
}

# ECR outputs
output "ecr_repository_url" {
  description = "URL of the ECR repository"
  value       = module.ecr.repository_url
}

# EKS outputs
output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "Endpoint of the EKS cluster"
  value       = module.eks.cluster_endpoint
}

# Jenkins outputs
output "jenkins_url" {
  description = "URL of the Jenkins instance"
  value       = module.jenkins.jenkins_url
}

output "jenkins_admin_password" {
  description = "Admin password for Jenkins"
  value       = module.jenkins.admin_password
  sensitive   = true
}

# Argo CD outputs
output "argo_cd_url" {
  description = "URL of the Argo CD instance"
  value       = module.argo_cd.argo_cd_url
}

output "argo_cd_admin_password" {
  description = "Admin password for Argo CD"
  value       = module.argo_cd.admin_password
  sensitive   = true
} 