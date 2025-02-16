#!/bin/bash

BUCKET_NAME="test"
REGION="ap-south-1"

# Check if the bucket exists
aws s3api head-bucket --bucket "$BUCKET_NAME" --region "$REGION" 2>/dev/null

if [ $? -eq 0 ]; then
    echo "Bucket '$BUCKET_NAME' exists. Importing to Terraform..."
    terraform import aws_s3_bucket.website_bucket "$BUCKET_NAME"
else
    echo "Bucket '$BUCKET_NAME' does not exist. Proceeding without import."
fi
