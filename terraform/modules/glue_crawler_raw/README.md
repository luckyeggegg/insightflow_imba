# Glue Crawler Raw Module

This module creates AWS Glue crawlers to automatically discover and catalog raw data stored in S3.

## Architecture

The module creates:
- **Glue Catalog Database**: Central metadata repository for raw data tables
- **IAM Role & Policies**: Proper permissions for crawlers to access S3 and write to Glue catalog
- **Individual Crawlers**: One crawler per table for better control and monitoring

## Features

- **Parameterized Configuration**: Uses variables for bucket names and prefixes instead of hardcoded values
- **Separated IAM Resources**: IAM roles and policies are in a separate file for better organization
- **Raw Data Focused**: All crawlers and IAM resources are specifically named for raw data processing
- **Automatic S3 Structure**: Creates required S3 directory structure automatically via Terraform
- **Comprehensive Tagging**: Consistent tagging across all resources
- **Future-Ready**: Includes commented configurations for order_products tables
- **Partition Support**: Handles partitioned data structure (year/month/day/hhmm)
- **Compressed File Support**: Ready to handle .gz compressed files
- **Zero Manual Setup**: No manual scripts required - everything handled by Terraform

## Usage

```hcl
module "glue_crawler_raw" {
  source = "./modules/glue_crawler_raw"
  
  env                  = "dev"
  s3_bucket_name      = "your-raw-data-bucket"
  s3_raw_data_prefix  = "data/batch"
  database_name       = "imba_raw_data_catalog"
  table_prefix        = "raw_"
  
  tags = {
    Project     = "InsightFlow"
    Environment = "dev"
    Owner       = "DataTeam"
  }
}
```

## Data Structure Expected

```
s3://bucket-name/data/batch/
├── orders/
│   └── year=2024/month=01/day=15/hhmm=1430/orders_part1.csv
├── products/
│   └── year=2024/month=01/day=15/hhmm=1430/products_part1.csv
├── departments/
│   └── year=2024/month=01/day=15/hhmm=1430/departments_part1.csv
├── aisles/
│   └── year=2024/month=01/day=15/hhmm=1430/aisles_part1.csv
├── order_products__prior/
│   └── year=2024/month=01/day=15/hhmm=1430/order_products__prior_part1.csv.gz
└── order_products__train/
    └── year=2024/month=01/day=15/hhmm=1430/order_products__train_part1.csv.gz
```

## Why Separate Crawlers?

Using one crawler per table provides:
1. **Individual Control**: Each table can have different schedules, configurations
2. **Better Monitoring**: Easier to identify which table has issues
3. **Schema Evolution**: Independent schema change handling per table
4. **Performance**: Parallel crawling and faster individual runs
5. **Granular Permissions**: Table-specific access control if needed

## Future Tables

The module includes commented configurations for:
- `order_products__prior`
- `order_products__train`

These can be uncommented when the data becomes available. They're configured to handle compressed (.gz) files.

## Outputs

- `glue_database_name`: Name of the created Glue database
- `glue_database_arn`: ARN of the Glue database
- `glue_role_arn`: ARN of the IAM role used by crawlers
- `crawler_names`: Map of all crawler names
- `table_names`: Map of expected table names after crawling
