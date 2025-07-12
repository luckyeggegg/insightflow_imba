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