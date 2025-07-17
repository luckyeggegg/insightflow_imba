# =============================
# S3 Directory Structure for Glue Crawlers
# =============================
# 🚀 方案1：智能检测 - 自动判断是否需要创建占位符

locals {
  table_names = ["orders", "products", "departments", "aisles", "order_products_prior", "order_products_train"]
}

# � 检查每个表目录是否已有真实数据
data "aws_s3_objects" "existing_data" {
  for_each = toset(local.table_names)
  
  bucket = var.s3_bucket_name
  prefix = "${var.s3_raw_data_prefix}/${each.value}/"
}

# 🚀 智能占位符：只在目录为空时创建
resource "aws_s3_object" "glue_crawler_placeholders" {
  for_each = {
    for table in local.table_names : table => table
    # 智能检测逻辑：
    # 1. 过滤掉占位符文件
    # 2. 过滤掉目录路径（以/结尾）
    # 3. 只有当没有真实数据文件时才创建占位符
    if length([
      for key in data.aws_s3_objects.existing_data[table].keys :
      key if !endswith(key, "placeholder.txt") && 
             !endswith(key, "_placeholder_for_crawler.txt") &&
             !endswith(key, "/") &&
             !strcontains(key, "_$folder$")  # 排除 S3 文件夹标记
    ]) == 0
  }
  
  bucket = var.s3_bucket_name
  key    = "${var.s3_raw_data_prefix}/${each.value}/_placeholder_for_crawler.txt"
  
  # 🔧 固定内容，避免 timestamp() 导致的重复更新
  content = <<EOF
# Glue Crawler 智能占位符
# Purpose: 确保 S3 目录存在以供 Glue Crawler 部署使用
# Status: 当检测到真实数据时，此文件会被自动忽略

Table: ${each.value}
S3 Path: s3://${var.s3_bucket_name}/${var.s3_raw_data_prefix}/${each.value}/
Environment: ${var.env}
Auto-managed: true

# 📝 说明：
# - 此文件仅在目录为空时创建
# - 有真实数据时会自动跳过创建
# - 安全删除，不影响爬虫运行
EOF

  tags = merge(var.tags, {
    Name        = "glue-crawler-smart-placeholder-${each.value}"
    Environment = var.env
    Purpose     = "SmartDirectoryStructure"
    Table       = each.value
    AutoManaged = "true"
  })
}
