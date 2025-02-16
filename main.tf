variable "aws_access_key_id" {
  description = "AWS Access Key ID"
  type        = string
  default     = ""
}

variable "aws_secret_access_key" {
  description = "AWS Secret Access Key"
  type        = string
  default     = ""
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "ap-south-1"
}

variable "bucket_name" {
  description = "S3 Bucket Name"
  type        = string
  default     = "test"
}

# AWS Provider Configuration
provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
}

# S3 Bucket Resource
resource "aws_s3_bucket" "website_bucket" {
  bucket = var.bucket_name
  acl    = "private"  

  website {
    index_document = "index.html"
  }
}

resource "aws_s3_bucket_public_access_block" "website_bucket_public_access" {
  bucket = aws_s3_bucket.website_bucket.bucket

  block_public_acls   = false  
  ignore_public_acls  = false
  block_public_policy = false
}

# S3 Bucket Object (Website Files)
resource "aws_s3_bucket_object" "website_files" {
  for_each = fileset("./quizz-app", "**/*")  # Loops through the files in 'quizz-app'

  bucket      = aws_s3_bucket.website_bucket.bucket
  key         = each.value
  source      = "./quizz-app/${each.value}"
  acl         = "public-read"

  # Content-Type based on file extension
  content_type = lookup({
    html = "text/html",
    css  = "text/css",
    js   = "application/javascript",
    png  = "image/png",
    jpg  = "image/jpeg",
    jpeg = "image/jpeg",
    gif  = "image/gif",
    svg  = "image/svg+xml",
    json = "application/json",
    txt  = "text/plain",
    woff = "font/woff",
    woff2 = "font/woff2",
    ttf  = "font/ttf",
    otf  = "font/otf"
  }, split(".", each.value)[length(split(".", each.value)) - 1], "application/octet-stream")
}

