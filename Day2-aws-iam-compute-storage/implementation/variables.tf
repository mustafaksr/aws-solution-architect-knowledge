variable "db_instance_master_password" {
  description = "Master password for the RDS instance"
  type        = string
  default = "123456789"
  sensitive = true
}

variable "output_bucket_name" {
  description = "Unique name for the S3 bucket to store photos"
  type        = string
  default = "output-bucket-streamlit-fs57ef"
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-2"
}
