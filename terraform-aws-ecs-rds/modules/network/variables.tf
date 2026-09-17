variable "name" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "availability_zones" {
  type = list(string)
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_subnet_cidrs" {
  type = list(string)
}

variable "database_subnet_cidrs" {
  type = list(string)
}

variable "nat_gateway_count" {
  type    = number
  default = 2

  validation {
    condition     = var.nat_gateway_count >= 1 && var.nat_gateway_count <= length(var.availability_zones)
    error_message = "nat_gateway_count must be between 1 and the number of availability zones."
  }
}

variable "tags" {
  type    = map(string)
  default = {}
}
