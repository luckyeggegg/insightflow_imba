variable "raw_bucket" {
  description = "Name of the raw S3 bucket"
  type        = string
}
variable "bucket_names" {
  description = "List of two S3 bucket names"
  type        = list(string)
  validation {
    condition     = length(var.bucket_names) == 2
    error_message = "You must provide exactly two bucket names."
  }
}
