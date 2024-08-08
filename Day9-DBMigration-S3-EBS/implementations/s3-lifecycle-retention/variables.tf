
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-2"
}

variable "bucket_name" {

  description = "Enter unique bucket name."
  default = "test-lifecyle-retention-versioning-g4r9h7h6r34n"
  
}