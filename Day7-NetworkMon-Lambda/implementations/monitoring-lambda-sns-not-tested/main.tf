# Provider Configuration
provider "aws" {
  region = var.aws_region # Change the region as needed
}

# Reference the default VPC
data "aws_vpc" "default" {
  default = true
}

# Key Pair
resource "aws_key_pair" "my_key_pair" {
  key_name   = "my-aws-key"
  public_key = file("~/.ssh/my-aws-key.pub")
}

# Reference the default subnet
data "aws_subnet" "default_subnet" {
  filter {
    name   = "availabilityZone"
    values = ["${var.aws_region}a"]
  }

  filter {
    name   = "defaultForAz"
    values = ["true"]
  }

  vpc_id = data.aws_vpc.default.id
}




# Create Security Group in the default VPC
resource "aws_security_group" "web_security_group" {
  vpc_id = data.aws_vpc.default.id

# ICMP
ingress {
  from_port   = -1
  to_port     = -1
  protocol    = "icmp"
  cidr_blocks = [data.aws_subnet.default_subnet.cidr_block]
}

  # HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # HTTPS
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# IAM Role for Lambda
resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# IAM Policy for Lambda to interact with EC2 and CloudWatch
resource "aws_iam_role_policy" "lambda_policy" {
  name   = "lambda_policy"
  role   = aws_iam_role.lambda_exec_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = [
          "ec2:DescribeInstances",
          "ec2:StopInstances",
          "logs:*",
          "cloudwatch:*"
        ],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

# Lambda Function
resource "aws_lambda_function" "abuse_report_handler" {
  filename         = "lambda.zip" 
  function_name    = "abuse_report_handler"
  role             = aws_iam_role.lambda_exec_role.arn
  handler          = "lambda_function.lambda_handler" 
  runtime          = "python3.11"                      
  
  source_code_hash = filebase64sha256("lambda.zip")

  environment {
    variables = {
      SNS_TOPIC_ARN = aws_sns_topic.abuse_notification.arn
    }
  }
}

# CloudWatch Event Rule
resource "aws_cloudwatch_event_rule" "abuse_event_rule" {
  name        = "abuse_event_rule"
  description = "Trigger Lambda on abuse report"
  event_pattern = jsonencode({
    "source": ["aws.ec2"],
    "detail-type": ["EC2 Instance State-change Notification"],
    "detail": {
      "state": ["running"]
    }
  })
}

# CloudWatch Event Target for Lambda
resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.abuse_event_rule.name
  target_id = "abuse_lambda"
  arn       = aws_lambda_function.abuse_report_handler.arn
}

# Permission for CloudWatch to invoke Lambda
resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.abuse_report_handler.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.abuse_event_rule.arn
}

# SNS Topic
resource "aws_sns_topic" "abuse_notification" {
  name = "abuse_notification"
}

# SNS Subscription
resource "aws_sns_topic_subscription" "incident_response_team" {
  topic_arn = aws_sns_topic.abuse_notification.arn
  protocol  = "email"
  endpoint  = var.incident_response_email # Replace with your email
}

# EC2 Instance (Example)
resource "aws_instance" "example" {
  ami           = var.ec2_ami
  subnet_id              = data.aws_subnet.default_subnet.id
  vpc_security_group_ids = [aws_security_group.web_security_group.id]
  key_name               = aws_key_pair.my_key_pair.key_name

  instance_type = "t2.micro"
  tags = {
    Name = "Deployed instance"
  }
}

# Grant SNS publish permission to Lambda
resource "aws_lambda_permission" "allow_sns_publish" {
  statement_id  = "AllowSNSPublish"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.abuse_report_handler.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.abuse_notification.arn
}

# Outputs
output "lambda_function_name" {
  value = aws_lambda_function.abuse_report_handler.function_name
}

output "sns_topic_arn" {
  value = aws_sns_topic.abuse_notification.arn
}

output "ec2_instance_id" {
  value = aws_instance.example.id
}
