output "rds_endpoint" {
  value = module.rds_postgresql.rds_endpoint
}

output "rds_host" {
  value = module.rds_postgresql.rds_host
}

output "rds_port" {
  description = "RDS PostgreSQL port"
  value       = module.rds_postgresql.rds_port
}