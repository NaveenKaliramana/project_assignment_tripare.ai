resource "aws_security_group" "rds" {
  name        = "${var.name}-rds-sg"
  description = "Allow PostgreSQL only from ECS tasks"
  vpc_id      = var.vpc_id

  ingress {
    description     = "PostgreSQL from ECS"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.ecs_security_group_id]
  }

  egress {
    description = "Outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.name}-rds-sg"
  })
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.name}-subnet-group"
  subnet_ids = var.database_subnet_ids

  tags = merge(var.tags, {
    Name = "${var.name}-subnet-group"
  })
}

resource "aws_db_instance" "this" {
  identifier = "${var.name}-postgres"

  engine         = var.engine
  engine_version = var.engine_version
  instance_class = var.instance_class

  allocated_storage     = var.allocated_storage
  storage_type          = "gp3"
  storage_encrypted     = true
  max_allocated_storage = var.allocated_storage * 2

  db_name  = var.database_name
  username = var.master_username
  password = var.master_password
  port     = 5432

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  publicly_accessible    = false

  backup_retention_period = var.backup_retention_period
  backup_window           = "03:00-04:00"
  maintenance_window      = "sun:04:00-sun:05:00"

  deletion_protection       = var.deletion_protection
  skip_final_snapshot       = false
  final_snapshot_identifier = "${var.name}-final-snapshot"

  auto_minor_version_upgrade = true
  copy_tags_to_snapshot      = true

  tags = merge(var.tags, {
    Name = "${var.name}-postgres"
  })
}
