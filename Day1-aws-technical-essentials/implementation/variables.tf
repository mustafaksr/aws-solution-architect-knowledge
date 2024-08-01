variable "db_instance_master_password" {
  description = "Master password for the RDS instance"
  type        = string
  sensitive = true
}

variable "photo_bucket_name" {
  description = "Unique name for the S3 bucket to store photos"
  type        = string
  default = "photo-bucket-aws-s3-5fe68r"
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-2"
}
