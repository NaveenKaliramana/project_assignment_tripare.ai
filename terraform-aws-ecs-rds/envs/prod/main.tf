locals {
  name = "${var.project_name}-${var.environment}"

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "random_password" "db" {
  length  = 32
  special = true
}

module "network" {
  source = "../../modules/network"

  name               = local.name
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones

  public_subnet_cidrs = [
    "10.20.1.0/24",
    "10.20.2.0/24"
  ]

  private_subnet_cidrs = [
    "10.20.11.0/24",
    "10.20.12.0/24"
  ]

  database_subnet_cidrs = [
    "10.20.21.0/24",
    "10.20.22.0/24"
  ]

  nat_gateway_count = 2
  tags              = local.common_tags
}

module "ecs" {
  source = "../../modules/ecs"

  name               = local.name
  vpc_id             = module.network.vpc_id
  public_subnet_ids  = module.network.public_subnet_ids
  private_subnet_ids = module.network.private_subnet_ids

  container_image = var.container_image
  container_port  = 80

  task_cpu      = 512
  task_memory   = 1024
  desired_count = 2

  tags = local.common_tags
}

module "rds" {
  source = "../../modules/rds"

  name                = local.name
  vpc_id              = module.network.vpc_id
  database_subnet_ids = module.network.database_subnet_ids

  ecs_security_group_id = module.ecs.ecs_security_group_id

  instance_class         = "db.t4g.small"
  allocated_storage      = 50
  backup_retention_period = 14
  deletion_protection    = true
  multi_az               = true

  master_username = "appadmin"
  master_password = random_password.db.result

  tags = local.common_tags
}
