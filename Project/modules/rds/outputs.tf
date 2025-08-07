# Shared resources outputs
output "db_subnet_group_id" {
  description = "The ID of the DB subnet group"
  value       = aws_db_subnet_group.this.id
}

output "db_subnet_group_arn" {
  description = "The ARN of the DB subnet group"
  value       = aws_db_subnet_group.this.arn
}

output "security_group_id" {
  description = "The ID of the security group"
  value       = aws_security_group.this.id
}

output "security_group_arn" {
  description = "The ARN of the security group"
  value       = aws_security_group.this.arn
}

output "parameter_group_id" {
  description = "The ID of the parameter group"
  value       = aws_db_parameter_group.this.id
}

output "parameter_group_arn" {
  description = "The ARN of the parameter group"
  value       = aws_db_parameter_group.this.arn
}

# Regular RDS Instance outputs
output "rds_instance_id" {
  description = "The ID of the RDS instance"
  value       = var.use_aurora ? null : aws_db_instance.this[0].id
}

output "rds_instance_arn" {
  description = "The ARN of the RDS instance"
  value       = var.use_aurora ? null : aws_db_instance.this[0].arn
}

output "rds_instance_endpoint" {
  description = "The connection endpoint of the RDS instance"
  value       = var.use_aurora ? null : aws_db_instance.this[0].endpoint
}

output "rds_instance_address" {
  description = "The address of the RDS instance"
  value       = var.use_aurora ? null : aws_db_instance.this[0].address
}

output "rds_instance_port" {
  description = "The port of the RDS instance"
  value       = var.use_aurora ? null : aws_db_instance.this[0].port
}

# Aurora Cluster outputs
output "aurora_cluster_id" {
  description = "The ID of the Aurora cluster"
  value       = var.use_aurora ? aws_rds_cluster.this[0].id : null
}

output "aurora_cluster_arn" {
  description = "The ARN of the Aurora cluster"
  value       = var.use_aurora ? aws_rds_cluster.this[0].arn : null
}

output "aurora_cluster_endpoint" {
  description = "The cluster endpoint of the Aurora cluster"
  value       = var.use_aurora ? aws_rds_cluster.this[0].endpoint : null
}

output "aurora_cluster_reader_endpoint" {
  description = "The cluster reader endpoint of the Aurora cluster"
  value       = var.use_aurora ? aws_rds_cluster.this[0].reader_endpoint : null
}

output "aurora_cluster_port" {
  description = "The port of the Aurora cluster"
  value       = var.use_aurora ? aws_rds_cluster.this[0].port : null
}

output "aurora_instance_ids" {
  description = "The IDs of the Aurora cluster instances"
  value       = var.use_aurora ? aws_rds_cluster_instance.this[*].id : []
}

output "aurora_instance_endpoints" {
  description = "The endpoints of the Aurora cluster instances"
  value       = var.use_aurora ? aws_rds_cluster_instance.this[*].endpoint : []
}

# Common outputs
output "database_type" {
  description = "The type of database created (Aurora or RDS)"
  value       = var.use_aurora ? "Aurora" : "RDS"
}

output "engine" {
  description = "The database engine used"
  value       = var.engine
}

output "engine_version" {
  description = "The database engine version used"
  value       = var.engine_version
}

output "username" {
  description = "The master username for the database"
  value       = var.username
  sensitive   = true
}

output "port" {
  description = "The port on which the database accepts connections"
  value       = var.port
} 