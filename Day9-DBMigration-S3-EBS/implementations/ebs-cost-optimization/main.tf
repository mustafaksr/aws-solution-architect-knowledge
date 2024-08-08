provider "aws" {
  region = var.aws_region  # Specify your AWS region
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

# Create an EBS volume
resource "aws_ebs_volume" "web_app_volume" {
  availability_zone = "${var.aws_region}a"  # Specify the availability zone
  size              = 100           # Initial volume size in GB
  type              = "gp3"         # Volume type for cost-effectiveness
  iops              = 3000          # Provisioned IOPS
  throughput        = 125           # Provisioned throughput
  
  tags = {
    Name        = "WebAppVolume"
    Environment = "Production"
    CreatedBy   = "Terraform"
  }
}

# Create IAM Role for EC2 Instance
resource "aws_iam_role" "instance_role" {
  name = "ec2-instance-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

# Attach policies to the IAM Role
resource "aws_iam_role_policy_attachment" "instance_role_ssm_policy_attachment" {
  role       = aws_iam_role.instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}

# Create IAM Instance Profile
resource "aws_iam_instance_profile" "instance_role_profile" {
  name = "instance-role-profile"
  role = aws_iam_role.instance_role.name
}

# Define an EC2 instance
resource "aws_instance" "web_app_instance" {
  ami                    = "ami-003932de22c285676" 
  instance_type          = "t2.micro"
  subnet_id              = data.aws_subnet.default_subnet.id
  vpc_security_group_ids = [aws_security_group.web_security_group.id]
  iam_instance_profile   = aws_iam_instance_profile.instance_role_profile.name
  key_name               = aws_key_pair.my_key_pair.key_name

  tags = {
    Name = "EBS-Test-Instance"
  }
}

# Attach the EBS volume to an EC2 instance
resource "aws_volume_attachment" "volume_attachment" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.web_app_volume.id
  instance_id = aws_instance.web_app_instance.id
}

# Define the IAM policy document for assuming the role
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["dlm.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# Create the IAM role for Data Lifecycle Manager
resource "aws_iam_role" "dlm_lifecycle_role" {
  name               = "dlm-lifecycle-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

# Define the IAM policy document for DLM lifecycle management
data "aws_iam_policy_document" "dlm_lifecycle" {
  statement {
    effect = "Allow"

    actions = [
      "ec2:CreateSnapshot",
      "ec2:CreateSnapshots",
      "ec2:DeleteSnapshot",
      "ec2:DescribeInstances",
      "ec2:DescribeVolumes",
      "ec2:DescribeSnapshots",
    ]

    resources = ["*"]
  }

  statement {
    effect    = "Allow"
    actions   = ["ec2:CreateTags"]
    resources = ["arn:aws:ec2:*::snapshot/*"]
  }
}

# Attach the policy to the IAM role
resource "aws_iam_role_policy" "dlm_lifecycle" {
  name   = "dlm-lifecycle-policy"
  role   = aws_iam_role.dlm_lifecycle_role.id
  policy = data.aws_iam_policy_document.dlm_lifecycle.json
}

# Define the Data Lifecycle Manager policy
resource "aws_dlm_lifecycle_policy" "example" {
  description        = "Lifecycle policy for EBS volume snapshots"
  execution_role_arn = aws_iam_role.dlm_lifecycle_role.arn
  state              = "ENABLED"

  policy_details {
    resource_types = ["VOLUME"]

    schedule {
      name = "Daily Snapshots for 2 Weeks"

      create_rule {
        interval      = 24
        interval_unit = "HOURS"
        times         = ["23:45"]
      }

      retain_rule {
        count = 14
      }

      # Tags to be added to snapshots created by this policy
      tags_to_add = {
        SnapshotCreator = "DLM"
        Environment     = "Production" # Specific tags for snapshots
      }

      copy_tags = false
    }

    # Tags to match the volumes that this policy should apply to
    target_tags = {
      Snapshot = "true"
    }
  }
}

# Create an SNS topic
resource "aws_sns_topic" "example" {
  name = "example-sns-topic"
}

# Subscribe an email address to the SNS topic
resource "aws_sns_topic_subscription" "example_email" {
  topic_arn = aws_sns_topic.example.arn
  protocol  = "email"
  endpoint  = "mustafakeser@zoho.com"  # Replace with the desired email address
}

# Define a CloudWatch alarm
resource "aws_cloudwatch_metric_alarm" "ebs_utilization_alarm" {
  alarm_name                = "EBS_Utilization_Alarm"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = 1
  metric_name               = "VolumeWriteOps"
  namespace                 = "AWS/EBS"
  period                    = 300
  statistic                 = "Sum"
  threshold                 = 1000
  alarm_description         = "Alarm for high EBS write operations"
  insufficient_data_actions = [aws_sns_topic.example.arn]

  # Other configurations...
}

# Output the SNS topic ARN
output "sns_topic_arn" {
  value = aws_sns_topic.example.arn
}

# Output the EBS volume ID
output "ebs_volume_id" {
  value = aws_ebs_volume.web_app_volume.id
}