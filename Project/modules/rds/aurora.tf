# Aurora Cluster (when use_aurora = true)
resource "aws_rds_cluster" "this" {
  count = var.use_aurora ? 1 : 0

  cluster_identifier = var.identifier

  # Engine configuration
  engine               = var.engine
  engine_version       = var.engine_version
  engine_mode          = "provisioned"

  # Network configuration
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.this.id]

  # Credentials
  master_username = var.username
  master_password = var.password
  port            = var.port

  # Backup and maintenance
  backup_retention_period = var.backup_retention_period
  backup_window          = var.backup_window
  preferred_backup_window = var.backup_window
  preferred_maintenance_window = var.maintenance_window

  # Storage
  storage_encrypted = var.storage_encrypted

  # Deletion protection
  deletion_protection = var.deletion_protection

  # Final snapshot
  skip_final_snapshot    = var.skip_final_snapshot
  final_snapshot_identifier = var.final_snapshot_identifier

  # Parameter group
  db_cluster_parameter_group_name = aws_db_parameter_group.this.name

  # Auto pause (for dev/test environments)
  enable_http_endpoint = false

  # Tags
  tags = merge(var.tags, {
    Name = var.identifier
    Type = "Aurora Cluster"
  })

  lifecycle {
    ignore_changes = [
      master_password,
    ]
  }
}

# Aurora Cluster Instances
resource "aws_rds_cluster_instance" "this" {
  count = var.use_aurora ? var.aurora_cluster_instances : 0

  identifier         = "${var.identifier}-${count.index + 1}"
  cluster_identifier = aws_rds_cluster.this[0].id

  # Instance configuration
  instance_class = var.aurora_instance_class
  engine         = var.engine
  engine_version = var.engine_version

  # Network configuration
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.this.id]

  # Parameter group
  db_parameter_group_name = aws_db_parameter_group.this.name

  # Performance insights
  performance_insights_enabled = true
  performance_insights_retention_period = 7

  # Monitoring
  monitoring_interval = 60
  monitoring_role_arn = null # Will use default monitoring role

  # Auto scaling
  auto_minor_version_upgrade = true

  # Tags
  tags = merge(var.tags, {
    Name = "${var.identifier}-${count.index + 1}"
    Type = "Aurora Instance"
  })

  lifecycle {
    ignore_changes = [
      engine_version,
    ]
  }
} 