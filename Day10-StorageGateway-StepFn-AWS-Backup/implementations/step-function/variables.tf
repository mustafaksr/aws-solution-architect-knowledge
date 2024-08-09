
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-2"
}

variable "output_bucket" {
  default = "output-bucket-b54e6r84bt3h"

}


variable "data_bucket" {
  default = "data-bucket-b54e6r84bt3h"

}