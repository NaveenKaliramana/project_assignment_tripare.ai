terraform {
  backend "s3" {
    bucket       = "terraform-backend-s3-bucket-name"
    key          = "ecs-rds/dev/terraform.tfstate"
    region       = "ap-south-1"
    encrypt      = true
    use_lockfile = true
  }
}
