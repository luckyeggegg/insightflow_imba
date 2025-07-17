output "glue_database_name" {
  description = "Name of the Glue catalog database"
  value       = aws_glue_catalog_database.raw_data_catalog.name
}

output "glue_database_arn" {
  description = "ARN of the Glue catalog database"
  value       = aws_glue_catalog_database.raw_data_catalog.arn
}

output "glue_role_arn" {
  description = "ARN of the IAM role used by Glue crawlers"
  value       = aws_iam_role.glue_crawler_role.arn
}

output "crawler_names" {
  description = "Names of all created crawlers"
  value = {
    orders                = aws_glue_crawler.raw_orders.name
    products              = aws_glue_crawler.raw_products.name
    departments           = aws_glue_crawler.raw_departments.name
    aisles                = aws_glue_crawler.raw_aisles.name
    order_products_prior  = aws_glue_crawler.raw_order_products_prior.name
    order_products_train  = aws_glue_crawler.raw_order_products_train.name
  }
}

output "table_names" {
  description = "Expected table names that will be created by crawlers"
  value = {
    orders                = "${var.table_prefix}orders"
    products              = "${var.table_prefix}products"
    departments           = "${var.table_prefix}departments"
    aisles                = "${var.table_prefix}aisles"
    order_products_prior  = "${var.table_prefix}order_products_prior"
    order_products_train  = "${var.table_prefix}order_products_train"
  }
}

output "s3_placeholder_objects" {
  description = "S3 placeholder objects created for directory structure"
  value = {
    for table, obj in aws_s3_object.glue_crawler_placeholders : table => {
      bucket = obj.bucket
      key    = obj.key
      etag   = obj.etag
    }
  }
}
