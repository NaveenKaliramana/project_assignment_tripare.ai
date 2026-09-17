output "alb_url" {
  value = "http://${module.ecs.alb_dns_name}"
}

output "rds_endpoint" {
  value = module.rds.db_endpoint
}

output "rds_security_group_id" {
  value = module.rds.rds_security_group_id
}
