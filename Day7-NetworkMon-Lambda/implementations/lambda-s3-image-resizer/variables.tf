variable "aws_region" {
  description = "AWS Default Region."
  default     = "us-east-2"
  type        = string

}

variable "ınput_bucket" {
  type        = string
  description = "your input bucket name"
  default     = "input-bucket-54s546gs4e84h"
}

variable "output_bucket" {
  type        = string
  description = "your output bucket name"
  default     = "output-bucket-54s546gs4e84h"
}

