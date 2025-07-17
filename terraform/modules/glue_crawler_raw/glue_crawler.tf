# =============================
# AWS Glue Crawlers for Raw Data Catalog
# S3 layout: s3://{bucket_name}/{s3_raw_data_prefix}/{table_name}/year=YYYY/month=MM/day=DD/hhmm=HHMM/{table}_part{x}.csv
# =============================

# Glue Catalog Database
resource "aws_glue_catalog_database" "raw_data_catalog" {
  name        = var.database_name
  description = "Glue database for raw data catalog - contains tables crawled from S3"

  tags = merge(var.tags, {
    Name        = var.database_name
    Environment = var.env
    Purpose     = "RawDataCatalog"
  })
}

# =============================
# Glue Crawlers - One per Table
# =============================
# Note: Using separate crawlers per table provides better control over:
# - Individual table schema changes
# - Separate scheduling if needed
# - Easier troubleshooting and monitoring
# - Granular permissions and configurations

# -----------------------------
# Orders Crawler
# -----------------------------
resource "aws_glue_crawler" "raw_orders" {
  name          = "${var.env}_crawler_raw_orders"
  role          = aws_iam_role.glue_crawler_role.arn
  database_name = aws_glue_catalog_database.raw_data_catalog.name
  table_prefix  = var.table_prefix
  description   = "Crawler for orders table in raw data"

  s3_target {
    path = "s3://${var.s3_bucket_name}/${var.s3_raw_data_prefix}/orders/"
    # Allow crawler to handle empty directories
    exclusions = []
  }

  configuration = jsonencode({
    Version = 1.0,
    Grouping = {
      TableGroupingPolicy = "CombineCompatibleSchemas"
    },
    CrawlerOutput = {
      Partitions = {
        AddOrUpdateBehavior = "InheritFromTable"
      }
    }
  })

  schema_change_policy {
    update_behavior = "UPDATE_IN_DATABASE"
    delete_behavior = "DEPRECATE_IN_DATABASE"
  }

  recrawl_policy {
    recrawl_behavior = "CRAWL_EVERYTHING"
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
  })
}

# -----------------------------
# Products Crawler
# -----------------------------
resource "aws_glue_crawler" "raw_products" {
  name          = "${var.env}_crawler_raw_products"
  role          = aws_iam_role.glue_crawler_role.arn
  database_name = aws_glue_catalog_database.raw_data_catalog.name
  table_prefix  = var.table_prefix
  description   = "Crawler for products table in raw data"

  s3_target {
    path = "s3://${var.s3_bucket_name}/${var.s3_raw_data_prefix}/products/"
    # Allow crawler to handle empty directories
    exclusions = []
  }

  configuration = jsonencode({
    Version = 1.0,
    Grouping = {
      TableGroupingPolicy = "CombineCompatibleSchemas"
    },
    CrawlerOutput = {
      Partitions = {
        AddOrUpdateBehavior = "InheritFromTable"
      }
    }
  })

  schema_change_policy {
    update_behavior = "UPDATE_IN_DATABASE"
    delete_behavior = "DEPRECATE_IN_DATABASE"
  }

  recrawl_policy {
    recrawl_behavior = "CRAWL_EVERYTHING"
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
  })
}

# -----------------------------
# Departments Crawler
# -----------------------------
resource "aws_glue_crawler" "raw_departments" {
  name          = "${var.env}_crawler_raw_departments"
  role          = aws_iam_role.glue_crawler_role.arn
  database_name = aws_glue_catalog_database.raw_data_catalog.name
  table_prefix  = var.table_prefix
  description   = "Crawler for departments table in raw data"

  s3_target {
    path = "s3://${var.s3_bucket_name}/${var.s3_raw_data_prefix}/departments/"
    # Allow crawler to handle empty directories
    exclusions = []
  }

  configuration = jsonencode({
    Version = 1.0,
    Grouping = {
      TableGroupingPolicy = "CombineCompatibleSchemas"
    },
    CrawlerOutput = {
      Partitions = {
        AddOrUpdateBehavior = "InheritFromTable"
      }
    }
  })

  schema_change_policy {
    update_behavior = "UPDATE_IN_DATABASE"
    delete_behavior = "DEPRECATE_IN_DATABASE"
  }

  recrawl_policy {
    recrawl_behavior = "CRAWL_EVERYTHING"
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
  })
}

# -----------------------------
# Aisles Crawler
# -----------------------------
resource "aws_glue_crawler" "raw_aisles" {
  name          = "${var.env}_crawler_raw_aisles"
  role          = aws_iam_role.glue_crawler_role.arn
  database_name = aws_glue_catalog_database.raw_data_catalog.name
  table_prefix  = var.table_prefix
  description   = "Crawler for aisles table in raw data"

  s3_target {
    path = "s3://${var.s3_bucket_name}/${var.s3_raw_data_prefix}/aisles/"
    # Allow crawler to handle empty directories
    exclusions = []
  }

  configuration = jsonencode({
    Version = 1.0,
    Grouping = {
      TableGroupingPolicy = "CombineCompatibleSchemas"
    },
    CrawlerOutput = {
      Partitions = {
        AddOrUpdateBehavior = "InheritFromTable"
      }
    }
  })

  schema_change_policy {
    update_behavior = "UPDATE_IN_DATABASE"
    delete_behavior = "DEPRECATE_IN_DATABASE"
  }

  recrawl_policy {
    recrawl_behavior = "CRAWL_EVERYTHING"
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
    Name        = "${var.env}_crawler_raw_aisles"
    Environment = var.env
    Table       = "aisles"
  })
}

# =============================
# FUTURE CRAWLERS (Currently Commented Out)
# =============================
# These crawlers are prepared for order_products tables when data becomes available
# Note: These tables may contain compressed (.gz) files

# # -----------------------------
# # Order Products Prior Crawler
# # -----------------------------
resource "aws_glue_crawler" "raw_order_products_prior" {
  name          = "${var.env}_crawler_raw_order-products-prior"
  role          = aws_iam_role.glue_crawler_role.arn
  database_name = aws_glue_catalog_database.raw_data_catalog.name
  table_prefix  = var.table_prefix
  description   = "Crawler for order_products__prior table in raw data"

  s3_target {
    path = "s3://${var.s3_bucket_name}/${var.s3_raw_data_prefix}/order_products__prior/"
    # Allow crawler to handle empty directories
    exclusions = []
  }

  configuration = jsonencode({
    Version = 1.0,
    Grouping = {
      TableGroupingPolicy = "CombineCompatibleSchemas"
    },
    CrawlerOutput = {
      Partitions = {
        AddOrUpdateBehavior = "InheritFromTable"
      }
    }
  })

  schema_change_policy {
    update_behavior = "UPDATE_IN_DATABASE"
    delete_behavior = "DEPRECATE_IN_DATABASE"
  }

  recrawl_policy {
    recrawl_behavior = "CRAWL_EVERYTHING"
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
    Name        = "${var.env}_crawler_raw_order-products-prior"
    Environment = var.env
    Table       = "order_products_prior"
  })
}

# # -----------------------------
# # Order Products Train Crawler
# # -----------------------------
resource "aws_glue_crawler" "raw_order_products_train" {
  name          = "${var.env}_crawler_raw_order-products-train"
  role          = aws_iam_role.glue_crawler_role.arn
  database_name = aws_glue_catalog_database.raw_data_catalog.name
  table_prefix  = var.table_prefix
  description   = "Crawler for order_products__train table in raw data"

  s3_target {
    path = "s3://${var.s3_bucket_name}/${var.s3_raw_data_prefix}/order_products__train/"
    # Allow crawler to handle empty directories
    exclusions = []
  }

  configuration = jsonencode({
    Version = 1.0,
    Grouping = {
      TableGroupingPolicy = "CombineCompatibleSchemas"
    },
    CrawlerOutput = {
      Partitions = {
        AddOrUpdateBehavior = "InheritFromTable"
      }
    }
  })

  schema_change_policy {
    update_behavior = "UPDATE_IN_DATABASE"
    delete_behavior = "DEPRECATE_IN_DATABASE"
  }

  recrawl_policy {
    recrawl_behavior = "CRAWL_EVERYTHING"
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
    Name        = "${var.env}_crawler_raw_order-products-train"
    Environment = var.env
    Table       = "order_products_train"
  })
}