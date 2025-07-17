# =============================
# S3 Directory Structure for Glue Crawlers
# =============================
# This ensures that all required S3 paths exist before Glue Crawlers are created

locals {
  table_names = ["orders", "products", "departments", "aisles", "order_products__prior", "order_products__train"]
}

# Create placeholder objects in S3 to ensure directory structure exists
resource "aws_s3_object" "glue_crawler_placeholders" {
  for_each = toset(local.table_names)
  
  bucket = var.s3_bucket_name
  key    = "${var.s3_raw_data_prefix}/${each.value}/placeholder.txt"
  
  content = <<EOF
# Placeholder file for Glue Crawler directory structure
# Created: ${timestamp()}
# Purpose: Ensure S3 directory exists for Glue Crawler deployment
# Note: This file will be overwritten when real data is uploaded

Table: ${each.value}
S3 Path: s3://${var.s3_bucket_name}/${var.s3_raw_data_prefix}/${each.value}/
Status: Directory structure ready for Glue Crawler
Environment: ${var.env}
EOF

  tags = merge(var.tags, {
    Name        = "glue-crawler-placeholder-${each.value}"
    Environment = var.env
    Purpose     = "DirectoryStructure"
    Table       = each.value
  })
}
