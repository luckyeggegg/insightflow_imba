variable "env" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket containing raw data"
  type        = string
}

variable "s3_raw_data_prefix" {
  description = "S3 prefix for raw data (e.g., data/batch)"
  type        = string
  default     = "data/batch"
}

variable "database_name" {
  description = "Name of the Glue catalog database"
  type        = string
  default     = "imba_raw_data_catalog"
}

variable "table_prefix" {
  description = "Prefix for all tables created by crawlers"
  type        = string
  default     = "raw_"
}

variable "crawler_schedule" {
  description = "Schedule for running crawlers (cron expression)"
  type        = string
  default     = null
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}
