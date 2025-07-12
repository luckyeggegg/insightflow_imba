# modules/data_ingestion/batch/variables.tf
# 本模块接收的变量，用于配置 Lambda + EventBridge + Snowflake + Crawler

variable "lambda_zip_path" {
  description = "Path to the Lambda deployment package zip file"
  type        = string
}

variable "lambda_function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "lambda_handler" {
  description = "Handler for the Lambda function"
  type        = string
  default     = "lambda_function.lambda_handler"
}

variable "lambda_runtime" {
  description = "Runtime for the Lambda function"
  type        = string
  default     = "python3.12"
}

variable "lambda_timeout" {
  description = "Timeout for the Lambda function (seconds)"
  type        = number
  default     = 900
}


variable "lambda_memory_size" {
  description = "Memory size (MB) for the Lambda function"
  type        = number
  default     = 128
}

variable "eventbridge_rule_name" {
  description = "Name of the EventBridge rule"
  type        = string
}

variable "eventbridge_rule_description" {
  description = "Description for the EventBridge rule"
  type        = string
  default     = "Trigger batch ingestion Lambda on schedule"
}

variable "eventbridge_schedule_expression" {
  description = "Schedule expression (cron) for EventBridge rule"
  type        = string
}

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

variable "raw_bucket" {
  description = "S3 bucket for raw data"
  type        = string
}

variable "clean_bucket" {
  description = "S3 bucket for clean data"
  type        = string
}