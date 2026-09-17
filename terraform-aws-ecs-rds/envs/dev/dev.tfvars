# Non-secret environment configuration.
# The backend bucket must exist before terraform init.

aws_region       = "ap-south-1"
project_name     = "ecs-rds-platform"
environment      = "dev"
vpc_cidr         = "10.10.0.0/16"
availability_zones = ["ap-south-1a", "ap-south-1b"]

container_image = "nginx:1.29-alpine"
