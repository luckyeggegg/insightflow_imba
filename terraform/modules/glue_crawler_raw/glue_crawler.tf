# =============================
# 简化版增量爬取 AWS Glue Crawlers 
# 专注于核心增量功能，去除复杂配置
# =============================

# Glue Catalog Database
resource "aws_glue_catalog_database" "raw_data_catalog" {
  name        = var.database_name
  description = "简化版原始数据目录 - 支持增量爬取"

  tags = merge(var.tags, {
    Name        = var.database_name
    Environment = var.env
    Purpose     = "SimpleIncrementalCrawling"
  })
}

# =============================
# 简化版增量爬虫 - 只保留核心功能
# =============================

# -----------------------------
# Orders Crawler (简化增量版)
# -----------------------------
resource "aws_glue_crawler" "raw_orders" {
  name          = "${var.env}_crawler_raw_orders"
  role          = aws_iam_role.glue_crawler_role.arn
  database_name = aws_glue_catalog_database.raw_data_catalog.name
  table_prefix  = var.table_prefix
  description   = "Orders表增量爬虫 - 只爬取新文件夹（无新数据时不报错）"

  s3_target {
    path = "s3://${var.s3_bucket_name}/${var.s3_raw_data_prefix}/orders/"
    # 排除临时文件和隐藏文件
    exclusions = [
      "**/_temporary/**",
      "**/.*"
    ]
  }

  # 智能Schema变更策略 - 根据爬取模式自动调整
  schema_change_policy {
    # 🚀 当使用 CRAWL_NEW_FOLDERS_ONLY 时，AWS要求两个行为都必须是LOG
    update_behavior = var.recrawl_behavior == "CRAWL_NEW_FOLDERS_ONLY" ? "LOG" : "UPDATE_IN_DATABASE"
    delete_behavior = "LOG" # 删除行为始终使用LOG（安全策略）
  }

  # 🚀 核心功能：增量爬取配置
  # 即使没有新数据，手动触发也不会报错，只是快速完成
  recrawl_policy {
    recrawl_behavior = var.recrawl_behavior
  }

  schedule = var.crawler_schedule

  depends_on = [
    aws_iam_role_policy_attachment.glue_service_role,
    aws_iam_role_policy.glue_s3_access,
    aws_iam_role_policy.glue_catalog_access,
    aws_iam_role_policy.glue_cloudwatch_logs,
    aws_s3_object.glue_crawler_placeholders
  ]

  tags = merge(var.tags, {
    Name        = "${var.env}_crawler_raw_orders"
    Environment = var.env
    Table       = "orders"
    CrawlType   = var.recrawl_behavior
  })
}

# -----------------------------
# Products Crawler (简化增量版)
# -----------------------------
resource "aws_glue_crawler" "raw_products" {
  name          = "${var.env}_crawler_raw_products"
  role          = aws_iam_role.glue_crawler_role.arn
  database_name = aws_glue_catalog_database.raw_data_catalog.name
  table_prefix  = var.table_prefix
  description   = "Products表增量爬虫 - 只爬取新文件夹"

  s3_target {
    path = "s3://${var.s3_bucket_name}/${var.s3_raw_data_prefix}/products/"
    exclusions = [
      "**/_temporary/**",
      "**/.*"
    ]
  }

  # 智能Schema变更策略 - 根据爬取模式自动调整
  schema_change_policy {
    # 🚀 当使用 CRAWL_NEW_FOLDERS_ONLY 时，AWS要求两个行为都必须是LOG
    update_behavior = var.recrawl_behavior == "CRAWL_NEW_FOLDERS_ONLY" ? "LOG" : "UPDATE_IN_DATABASE"
    delete_behavior = "LOG" # 删除行为始终使用LOG（安全策略）
  }

  # 🚀 核心功能：增量爬取配置
  recrawl_policy {
    recrawl_behavior = var.recrawl_behavior
  }

  schedule = var.crawler_schedule

  depends_on = [
    aws_iam_role_policy_attachment.glue_service_role,
    aws_iam_role_policy.glue_s3_access,
    aws_iam_role_policy.glue_catalog_access,
    aws_iam_role_policy.glue_cloudwatch_logs,
    aws_s3_object.glue_crawler_placeholders
  ]

  tags = merge(var.tags, {
    Name        = "${var.env}_crawler_raw_products"
    Environment = var.env
    Table       = "products"
    CrawlType   = var.recrawl_behavior
  })
}

# -----------------------------
# Departments Crawler (简化增量版)
# -----------------------------
resource "aws_glue_crawler" "raw_departments" {
  name          = "${var.env}_crawler_raw_departments"
  role          = aws_iam_role.glue_crawler_role.arn
  database_name = aws_glue_catalog_database.raw_data_catalog.name
  table_prefix  = var.table_prefix
  description   = "Departments表增量爬虫 - 只爬取新文件夹"

  s3_target {
    path = "s3://${var.s3_bucket_name}/${var.s3_raw_data_prefix}/departments/"
    exclusions = [
      "**/_temporary/**",
      "**/.*"
    ]
  }

  # 智能Schema变更策略 - 根据爬取模式自动调整
  schema_change_policy {
    # 🚀 当使用 CRAWL_NEW_FOLDERS_ONLY 时，AWS要求两个行为都必须是LOG
    update_behavior = var.recrawl_behavior == "CRAWL_NEW_FOLDERS_ONLY" ? "LOG" : "UPDATE_IN_DATABASE"
    delete_behavior = "LOG" # 删除行为始终使用LOG（安全策略）
  }

  # 🚀 核心功能：增量爬取配置
  recrawl_policy {
    recrawl_behavior = var.recrawl_behavior
  }

  schedule = var.crawler_schedule

  depends_on = [
    aws_iam_role_policy_attachment.glue_service_role,
    aws_iam_role_policy.glue_s3_access,
    aws_iam_role_policy.glue_catalog_access,
    aws_iam_role_policy.glue_cloudwatch_logs,
    aws_s3_object.glue_crawler_placeholders
  ]

  tags = merge(var.tags, {
    Name        = "${var.env}_crawler_raw_departments"
    Environment = var.env
    Table       = "departments"
    CrawlType   = var.recrawl_behavior
  })
}

# -----------------------------
# Aisles Crawler (简化增量版)
# -----------------------------
resource "aws_glue_crawler" "raw_aisles" {
  name          = "${var.env}_crawler_raw_aisles"
  role          = aws_iam_role.glue_crawler_role.arn
  database_name = aws_glue_catalog_database.raw_data_catalog.name
  table_prefix  = var.table_prefix
  description   = "Aisles表增量爬虫 - 只爬取新文件夹"

  s3_target {
    path = "s3://${var.s3_bucket_name}/${var.s3_raw_data_prefix}/aisles/"
    exclusions = [
      "**/_temporary/**",
      "**/.*"
    ]
  }

  # 智能Schema变更策略 - 根据爬取模式自动调整
  schema_change_policy {
    # 🚀 当使用 CRAWL_NEW_FOLDERS_ONLY 时，AWS要求两个行为都必须是LOG
    update_behavior = var.recrawl_behavior == "CRAWL_NEW_FOLDERS_ONLY" ? "LOG" : "UPDATE_IN_DATABASE"
    delete_behavior = "LOG" # 删除行为始终使用LOG（安全策略）
  }

  # 🚀 核心功能：增量爬取配置
  recrawl_policy {
    recrawl_behavior = var.recrawl_behavior
  }

  schedule = var.crawler_schedule

  depends_on = [
    aws_iam_role_policy_attachment.glue_service_role,
    aws_iam_role_policy.glue_s3_access,
    aws_iam_role_policy.glue_catalog_access,
    aws_iam_role_policy.glue_cloudwatch_logs,
    aws_iam_role_policy.glue_additional_permissions,
    aws_s3_object.glue_crawler_placeholders
  ]

  tags = merge(var.tags, {
    Name        = "${var.env}_crawler_raw_aisles"
    Environment = var.env
    Table       = "aisles"
    CrawlType   = var.recrawl_behavior
  })
}

# =============================
# FUTURE CRAWLERS (Currently Commented Out)
# =============================
# These crawlers are prepared for order_products tables when data becomes available
# Note: These tables may contain compressed (.gz) files

# -----------------------------
# Order Products Prior Crawler (简化增量版)
# -----------------------------
resource "aws_glue_crawler" "raw_order_products_prior" {
  name          = "${var.env}_crawler_raw_order_products_prior"
  role          = aws_iam_role.glue_crawler_role.arn
  database_name = aws_glue_catalog_database.raw_data_catalog.name
  table_prefix  = var.table_prefix
  description   = "Order Products Prior表增量爬虫 - 只爬取新文件夹"

  s3_target {
    path = "s3://${var.s3_bucket_name}/${var.s3_raw_data_prefix}/order_products_prior/"
    exclusions = [
      "**/_temporary/**",
      "**/.*"
    ]
  }

  # 智能Schema变更策略 - 根据爬取模式自动调整
  schema_change_policy {
    # 🚀 当使用 CRAWL_NEW_FOLDERS_ONLY 时，AWS要求两个行为都必须是LOG
    update_behavior = var.recrawl_behavior == "CRAWL_NEW_FOLDERS_ONLY" ? "LOG" : "UPDATE_IN_DATABASE"
    delete_behavior = "LOG" # 删除行为始终使用LOG（安全策略）
  }

  # 🚀 核心功能：增量爬取配置
  recrawl_policy {
    recrawl_behavior = var.recrawl_behavior
  }

  schedule = var.crawler_schedule

  depends_on = [
    aws_iam_role_policy_attachment.glue_service_role,
    aws_iam_role_policy.glue_s3_access,
    aws_iam_role_policy.glue_catalog_access,
    aws_iam_role_policy.glue_cloudwatch_logs,
    aws_s3_object.glue_crawler_placeholders
  ]

  tags = merge(var.tags, {
    Name        = "${var.env}_crawler_raw_order_products_prior"
    Environment = var.env
    Table       = "order_products_prior"
    CrawlType   = var.recrawl_behavior
  })
}

# -----------------------------
# Order Products Train Crawler (简化增量版)
# -----------------------------
resource "aws_glue_crawler" "raw_order_products_train" {
  name          = "${var.env}_crawler_raw_order_products_train"
  role          = aws_iam_role.glue_crawler_role.arn
  database_name = aws_glue_catalog_database.raw_data_catalog.name
  table_prefix  = var.table_prefix
  description   = "Order Products Train表增量爬虫 - 只爬取新文件夹"

  s3_target {
    path = "s3://${var.s3_bucket_name}/${var.s3_raw_data_prefix}/order_products_train/"
    exclusions = [
      "**/_temporary/**",
      "**/.*"
    ]
  }

  # 智能Schema变更策略 - 根据爬取模式自动调整
  schema_change_policy {
    # 🚀 当使用 CRAWL_NEW_FOLDERS_ONLY 时，AWS要求两个行为都必须是LOG
    update_behavior = var.recrawl_behavior == "CRAWL_NEW_FOLDERS_ONLY" ? "LOG" : "UPDATE_IN_DATABASE"
    delete_behavior = "LOG" # 删除行为始终使用LOG（安全策略）
  }

  # 🚀 核心功能：增量爬取配置
  recrawl_policy {
    recrawl_behavior = var.recrawl_behavior
  }

  schedule = var.crawler_schedule

  depends_on = [
    aws_iam_role_policy_attachment.glue_service_role,
    aws_iam_role_policy.glue_s3_access,
    aws_iam_role_policy.glue_catalog_access,
    aws_iam_role_policy.glue_cloudwatch_logs,
    aws_s3_object.glue_crawler_placeholders
  ]

  tags = merge(var.tags, {
    Name        = "${var.env}_crawler_raw_order_products_train"
    Environment = var.env
    Table       = "order_products_train"
    CrawlType   = var.recrawl_behavior
  })
}