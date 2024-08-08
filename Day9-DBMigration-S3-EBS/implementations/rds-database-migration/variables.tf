variable "db_instance_master_password" {
  description = "Master password for the RDS instance"
  type        = string
  default = "123456789"
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-2"
}
