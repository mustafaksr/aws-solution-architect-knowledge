variable "db_instance_master_password" {
  description = "Master password for the RDS instance"
  type        = string
  default     = "123456789"
  sensitive   = true
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-2"
}

variable "images_bucket_name" {
  description = "İmages buckets"
  type        = string
  default     = "my-app-images-bucket-8re7te4"
}

variable "docdb_cluster_user" {

  default   = "usertest1d64ef5"
  sensitive = true
}

variable "docdb_cluster_password" {

  default   = "fe6gr76ger8g4r5"
  sensitive = true
}