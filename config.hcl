# Vault Storage Backend Configuration for S3
storage "s3" {
  bucket = "vault-backend"      # The name of your S3 bucket
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
  region = "ap-south-1"          # AWS Region
  secure = true                  # Use HTTPS for communication with S3
}

# Listener configuration
listener "tcp" {
  address = "0.0.0.0:8200"      # Address and port Vault will listen on
  tls_disable = 1                # Disable TLS for simplicity (for production, TLS should be enabled)
}

# Enable the Vault UI (optional)
ui = true
