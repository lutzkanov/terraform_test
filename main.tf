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
  default = "ap-south-1"
}

variable "bucket_name" {
  default = "test"
}



provider "aws" {
  region = var.aws_region
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
}

resource "aws_s3_bucket" "website_bucket" {
  bucket = var.bucket_name
  acl    = "public-read"

  website {
    index_document = "index.html"
  }

  block_public_acls = false
  ignore_public_acls = false
  block_public_policy = false
  ignore_changes = [bucket]
}


  lifecycle {
    prevent_destroy = false
    ignore_changes = [
      bucket
    ]
  }
}

resource "aws_s3_bucket_object" "website_files" {
  for_each = fileset("./quizz-app", "**/*")

  bucket = aws_s3_bucket.website_bucket.bucket
  key    = each.value
  source = "./quizz-app/${each.value}"
  acl    = "public-read"
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

