provider "aws" {
  region = var.aws_region # Replace with your desired region
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = var.bucket_name # Replace with your unique bucket name
  acl    = "private"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = false
  }
  force_destroy = true
}

resource "aws_s3_bucket_lifecycle_configuration" "my_bucket_lifecycle" {
  bucket = aws_s3_bucket.my_bucket.id

  rule {
    id     = "frequent-access-rule"
    status = "Enabled"

    filter {
      prefix = ""
    }

    transition {
      days          = 180 # Transition to Standard-IA after 6 months
      storage_class = "STANDARD_IA"
    }

    expiration {
      days = 365 * 4 # Delete objects 4 years after transition to Standard-IA
    }
  }

  rule {
    id     = "one-year-rule"
    status = "Enabled"

    filter {
      prefix = ""
    }

    transition {
      days          = 365 # Transition to Glacier after 1 year
      storage_class = "GLACIER"
    }

    expiration {
      days = 365 * 4 # Delete objects 4 years after transition to Glacier
    }
  }

  rule {
    id     = "five-year-rule"
    status = "Enabled"

    filter {
      prefix = ""
    }

    expiration {
      days = 365 * 5 # Delete objects 5 years after creation
    }
  }
  
}
