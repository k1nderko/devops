variable "use_aurora" {
  description = "Whether to create Aurora Cluster (true) or regular RDS instance (false)"
  type        = bool
  default     = false
}

variable "identifier" {
  description = "The name of the RDS instance or Aurora cluster"
  type        = string
}

variable "engine" {
  description = "The database engine to use"
  type        = string
  default     = "postgres"
  validation {
    condition     = contains(["postgres", "mysql", "mariadb", "aurora-postgresql", "aurora-mysql"], var.engine)
    error_message = "Engine must be one of: postgres, mysql, mariadb, aurora-postgresql, aurora-mysql."
  }
}

variable "engine_version" {
  description = "The engine version to use"
  type        = string
  default     = "14.9"
}

variable "instance_class" {
  description = "The instance type of the RDS instance"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "The allocated storage in gigabytes (only for regular RDS instances)"
  type        = number
  default     = 20
}

variable "storage_type" {
  description = "One of 'standard' (magnetic), 'gp2' (general purpose SSD), or 'io1' (provisioned IOPS SSD)"
  type        = string
  default     = "gp2"
}

variable "storage_encrypted" {
  description = "Specifies whether the DB instance is encrypted"
  type        = bool
  default     = true
}

variable "multi_az" {
  description = "Specifies if the RDS instance is multi-AZ"
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "The days to retain backups for"
  type        = number
  default     = 7
}

variable "backup_window" {
  description = "The daily time range during which backups are created"
  type        = string
  default     = "03:00-04:00"
}

variable "maintenance_window" {
  description = "The window to perform maintenance in"
  type        = string
  default     = "sun:04:00-sun:05:00"
}

variable "deletion_protection" {
  description = "If the DB instance should have deletion protection enabled"
  type        = bool
  default     = false
}

variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted"
  type        = bool
  default     = false
}

variable "final_snapshot_identifier" {
  description = "The name of your final DB snapshot when this DB instance is deleted"
  type        = string
  default     = null
}

variable "username" {
  description = "Username for the master DB user"
  type        = string
  default     = "admin"
}

variable "password" {
  description = "Password for the master DB user"
  type        = string
  sensitive   = true
}

variable "port" {
  description = "The port on which the DB accepts connections"
  type        = number
  default     = 5432
}

variable "vpc_id" {
  description = "The VPC ID where the RDS instance will be created"
  type        = string
}

variable "subnet_ids" {
  description = "List of VPC subnet IDs for the DB subnet group"
  type        = list(string)
}

variable "vpc_cidr_blocks" {
  description = "List of VPC CIDR blocks for the security group"
  type        = list(string)
  default     = []
}

variable "allowed_security_group_ids" {
  description = "List of security group IDs to allow access to the database"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

# Aurora specific variables
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

variable "aurora_auto_pause" {
  description = "Whether to enable auto pause for Aurora cluster"
  type        = bool
  default     = false
}

variable "aurora_auto_pause_seconds" {
  description = "The time in seconds before an Aurora cluster is paused"
  type        = number
  default     = 300
}

# Parameter group variables
variable "max_connections" {
  description = "Maximum number of connections"
  type        = number
  default     = 100
}

variable "log_statement" {
  description = "Log statement setting (none, ddl, mod, all)"
  type        = string
  default     = "none"
  validation {
    condition     = contains(["none", "ddl", "mod", "all"], var.log_statement)
    error_message = "Log statement must be one of: none, ddl, mod, all."
  }
}

variable "work_mem" {
  description = "Work memory setting in MB"
  type        = number
  default     = 4
} 