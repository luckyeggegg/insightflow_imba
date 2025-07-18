
variable "snowflake_user" {
  description = "Snowflake user for Lambda environment"
  type        = string
}

variable "snowflake_password" {
  description = "Snowflake password for Lambda environment"
  type        = string
  sensitive   = true
}

variable "snowflake_account" {
  description = "Snowflake account identifier"
  type        = string
}

variable "snowflake_warehouse" {
  description = "Snowflake warehouse name"
  type        = string
}

variable "snowflake_role" {
  description = "Snowflake role"
  type        = string
}

variable "aws_region" {
  description = "AWS region for resources"
  type        = string
}

# S3
variable "raw_bucket" {
  description = "S3 bucket for raw data"
  type        = string
}

variable "clean_bucket" {
  description = "S3 bucket for clean data"
  type        = string
}

# EC2
variable "ami_id" {}
variable "instance_type" {}
variable "key_name" {}

# rds_postgresql
variable "db_name" {
  description = "Database name for RDS PostgreSQL"
  type        = string
}

variable "db_username" {
  description = "Master username for RDS PostgreSQL"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Master password for RDS PostgreSQL"
  type        = string
  sensitive   = true
}

# S3, glue_crawler_raw, Data Processing
variable "raw_prefix" {
  description = "S3 prefix/folder for raw data (e.g., 'data/batch/')"
  type        = string
}

variable "aws_az" {
  description = "Availability zone for DMS instance"
  type        = string
}

variable "recrawl_behavior" {
  description = "爬取行为: CRAWL_EVERYTHING(全量) 或 CRAWL_NEW_FOLDERS_ONLY(增量)"
  type        = string
  validation {
    condition = contains([
      "CRAWL_EVERYTHING",
      "CRAWL_NEW_FOLDERS_ONLY"
    ], var.recrawl_behavior)
    error_message = "Recrawl behavior must be either CRAWL_EVERYTHING or CRAWL_NEW_FOLDERS_ONLY."
  }
}

variable "crawler_schedule" {
  description = "Schedule for running crawlers (cron expression)"
  type        = string
  default     = "cron(0 15 30 * ? *)"
}