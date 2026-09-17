This repository provisions:

Internet - public ALB - private ECS/Fargate service - private RDS PostgreSQL

## Structure
infra/
- modules/
  -network/
  - ecs/
  rds/
- envs
  - dev/
  - prod/
- .github/
  - workflows/
    - terraform-plan.yml

## Architecture
- 1 VPC
- 2 public subnets for the ALB
- 2 private application subnets for ECS/Fargate
- 2 private database subnets for RDS
- Internet Gateway
- NAT Gateway(s) for private subnet egress
- Public Application Load Balancer
- ECS/Fargate cluster, task definition and service
- PostgreSQL RDS instance
- Security groups:
  - ALB: TCP/80 from the internet
  - ECS: TCP/80 only from the ALB security group
  - RDS: TCP/5432 only from the ECS security group
- RDS has no public IP

## Environment
Dev:
ECS dersired count: 1
ECS CPU: 256
ECS Memory: 512 MB
RDS Instance: db.t4g.micro
RDS Storgae: 20 GB
Backup Retention: 1 Day
Deletion Protection: False
Multi-AZ RDS: False
NAT Gateways: 1

Prod:
ECS dersired count: 2
ECS CPU: 512
ECS Memory: 1024 MB
RDS Instance: db.t4g.small
RDS Storgae: 50 GB
Backup Retention: 14 Day
Deletion Protection: True
Multi-AZ RDS: True
NAT Gateways: 2

## Backend
Terraform backends intentionally use placeholders:

terraform-backend-s3-bucket-name

Create a S3 bucket with same name before running 'terraform init'.

## Important Note
- Do not commit real database credentials.
- This example generates the RDS master password with 'random_password', which means the secret is stored in Terraform state. For a production implementation, prefer AWS Secrets Manager and a controlled secret-management workflow.
- Restrict application egress further if the application has known outbound dependencies.
- Consider VPC endpoints for ECR, CloudWatch Logs and S3 to reduce NAT dependency/cost.
- Add HTTPS/443 to the ALB with an ACM certificate before exposing a real application.
