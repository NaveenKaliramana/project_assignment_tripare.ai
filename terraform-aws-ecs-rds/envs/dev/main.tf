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
    "10.10.1.0/24",
    "10.10.2.0/24"
  ]

  private_subnet_cidrs = [
    "10.10.11.0/24",
    "10.10.12.0/24"
  ]

  database_subnet_cidrs = [
    "10.10.21.0/24",
    "10.10.22.0/24"
  ]

  nat_gateway_count = 1
  tags              = local.common_tags
}

module "ecs" {
  source = "../../modules/ecs"

  name              = local.name
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  private_subnet_ids = module.network.private_subnet_ids

  container_image = var.container_image
  container_port  = 80

  task_cpu     = 256
  task_memory  = 512
  desired_count = 1

  tags = local.common_tags
}

module "rds" {
  source = "../../modules/rds"

  name                = local.name
  vpc_id              = module.network.vpc_id
  database_subnet_ids = module.network.database_subnet_ids

  ecs_security_group_id = module.ecs.ecs_security_group_id

  instance_class        = "db.t4g.micro"
  allocated_storage     = 20
  backup_retention_period = 1
  deletion_protection   = false
  multi_az              = false

  master_username = "appadmin"
  master_password = random_password.db.result

  tags = local.common_tags
}
