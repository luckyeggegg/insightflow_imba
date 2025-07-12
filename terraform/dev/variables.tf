# variables.tf
# 声明必要的 Terraform 参数变量

variable "aws_region" {
  description = "AWS 区域"
  type        = string
}

# S3
variable "raw_bucket" {}
variable "clean_bucket" {}