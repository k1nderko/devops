# DB Subnet Group
resource "aws_db_subnet_group" "this" {
  name       = "${var.identifier}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = merge(var.tags, {
    Name = "${var.identifier}-subnet-group"
  })
}

# Security Group
resource "aws_security_group" "this" {
  name_prefix = "${var.identifier}-db-sg"
  vpc_id      = var.vpc_id

  # Allow database access from VPC CIDR blocks
  dynamic "ingress" {
    for_each = var.vpc_cidr_blocks
    content {
      from_port   = var.port
      to_port     = var.port
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
  }

  # Allow database access from specified security groups
  dynamic "ingress" {
    for_each = var.allowed_security_group_ids
    content {
      from_port       = var.port
      to_port         = var.port
      protocol        = "tcp"
      security_groups = [ingress.value]
    }
  }

  # Egress rule
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.identifier}-db-sg"
  })

  lifecycle {
    create_before_destroy = true
  }
}

# Parameter Group
resource "aws_db_parameter_group" "this" {
  family = var.use_aurora ? "${var.engine}${var.engine_version}" : "${var.engine}${var.engine_version}"
  name   = "${var.identifier}-parameter-group"

  dynamic "parameter" {
    for_each = local.parameter_group_parameters
    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  }

  tags = merge(var.tags, {
    Name = "${var.identifier}-parameter-group"
  })
}

# Local values for parameter group
locals {
  parameter_group_parameters = [
    {
      name  = "max_connections"
      value = tostring(var.max_connections)
    },
    {
      name  = "log_statement"
      value = var.log_statement
    },
    {
      name  = "work_mem"
      value = "${var.work_mem}MB"
    }
  ]

  # Determine the correct engine family for Aurora vs regular RDS
  engine_family = var.use_aurora ? "${var.engine}${var.engine_version}" : "${var.engine}${var.engine_version}"
} 