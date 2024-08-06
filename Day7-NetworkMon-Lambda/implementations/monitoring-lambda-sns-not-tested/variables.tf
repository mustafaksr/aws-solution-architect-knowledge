variable "aws_region" {
    description = "AWS Default Region."
    default = "us-east-2"
    type = string
  
}

variable "incident_response_email" {
    type = string
    description = "Email of incident responder."
    default = "mustafakeser@zoho.com"
}

variable "ec2_ami" {
    description = "Ubuntu EC2 AMI"
    type = string
    default = "ami-003932de22c285676"
  
}