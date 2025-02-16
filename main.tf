provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "website_bucket" {
  bucket = var.bucket_name
  acl    = "public-read"

  website {
    index_document = "index.html"
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

variable "aws_region" {
  default = "ap-south-1"
}

variable "bucket_name" {
  default = "test"
}
