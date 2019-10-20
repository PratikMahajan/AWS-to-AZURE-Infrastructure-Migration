
resource "aws_kms_key" "mykey" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket" "bucket" {
  bucket = "${var.env}-${var.s3_bucket_name}"
  acl    = "private"

  force_destroy = true

  lifecycle_rule {
    id      = "images"
    enabled = true

    prefix = "images/"

    tags = {
      "rule"      = "images"
    }

    transition {
      days          = 30
      storage_class = "STANDARD_IA" # or "ONEZONE_IA"
    }
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.mykey.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  tags = {
    Name   = var.s3_bucket_name
    ENV    = var.env
  }
}
