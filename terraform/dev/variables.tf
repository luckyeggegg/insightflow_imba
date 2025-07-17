
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
}

variable "db_password" {
  description = "Master password for RDS PostgreSQL"
  type        = string
  sensitive   = true
}

# dms
variable "raw_prefix" {
  description = "S3 prefix/folder for all DMS同步表的公共父目录,如 data/batch/"
  type        = string
}

variable "aws_az" {
  description = "Availability zone for DMS instance"
  type        = string
}