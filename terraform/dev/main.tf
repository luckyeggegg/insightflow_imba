# main.tf
# 顶层 Terraform 入口，包含 provider 配置与 module 加载

provider "aws" {
  region = var.aws_region
}

data "aws_caller_identity" "current" {}

module "s3_buckets" {
  source       = "../modules/s3_buckets"
  bucket_names = [var.raw_bucket, var.clean_bucket]
}

module "batch_ingestion" {
  source = "../modules/data_ingestion/batch"

  lambda_zip_path                = "../assets/batch_ingestion_lambda.zip"
  lambda_function_name           = "batch_ingestion"
  lambda_handler                 = "lambda_function.lambda_handler"
  lambda_runtime                 = "python3.13"
  lambda_timeout                 = 900
  lambda_memory_size             = 1024

  eventbridge_rule_name          = "batch_ingestion_trigger"
  eventbridge_rule_description   = "Trigger batch ingestion Lambda on 30th of every month at 00:00 Sydney time"
  # 悉尼时间0点，冬令时UTC+10=14点，夏令时UTC+11=13点。此表达式为每月30号悉尼时间0点（UTC 14点），如需兼容31号可调整为29-31
  eventbridge_schedule_expression = "cron(0 14 30 * ? *)"
  # 根据最后的项目需求调整

  snowflake_user                 = var.snowflake_user
  snowflake_password             = var.snowflake_password
  snowflake_account              = var.snowflake_account
  snowflake_warehouse            = var.snowflake_warehouse
  snowflake_role                 = var.snowflake_role

  aws_region                     = var.aws_region
  raw_bucket                     = var.raw_bucket
  clean_bucket                   = var.clean_bucket
}