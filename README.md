Project Structure

The project is organized into two main folders:

1. terraform-aws-ecs-rds
This folder contains the Terraform modules and configuration required to provision the AWS infrastructure for both Development and Production environments.

It includes:
Reusable Terraform modules for AWS infrastructure.
Environment-specific configurations for dev and prod.
AWS ECS and RDS infrastructure setup.
S3 backend configuration for securely storing Terraform state (.tfstate) files.

2. Docker + Local Database
This folder contains the configuration and scripts required to run the database locally using Docker.

It includes:
Docker Compose configuration for setting up the local database.
Database seed scripts for populating initial/test data.
Database backup scripts.
Database restore scripts.
Supporting configuration required for local database development.
