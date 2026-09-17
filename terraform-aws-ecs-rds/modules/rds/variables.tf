variable "name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "database_subnet_ids" {
  type = list(string)
}

variable "ecs_security_group_id" {
  type = string
}

variable "engine" {
  type    = string
  default = "postgres"
}

variable "engine_version" {
  type    = string
  default = "17.6"
}

variable "instance_class" {
  type = string
}

variable "allocated_storage" {
  type = number
}

variable "database_name" {
  type    = string
  default = "appdb"
}

variable "master_username" {
  type      = string
  sensitive = true
}

variable "master_password" {
  type      = string
  sensitive = true
}

variable "backup_retention_period" {
  type = number
}

variable "deletion_protection" {
  type = bool
}

variable "multi_az" {
  type = bool
}

variable "tags" {
  type    = map(string)
  default = {}
}
