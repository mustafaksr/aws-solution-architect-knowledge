provider "aws" {
  region = var.aws_region
}

# Create a VPC
resource "aws_vpc" "app_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Create subnets
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.app_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

# Create an Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.app_vpc.id
}

# Create a Route Table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.app_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

# Associate Route Table with Subnet
resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

# Create Security Group
resource "aws_security_group" "web_security_group" {
  vpc_id = aws_vpc.app_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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

resource "aws_subnet" "public_subnet_a" {
  vpc_id                  = aws_vpc.app_vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-east-2a" # Specify AZ
  map_public_ip_on_launch = true
}

resource "aws_subnet" "public_subnet_b" {
  vpc_id                  = aws_vpc.app_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-2b" # Specify AZ
  map_public_ip_on_launch = true
}


# Create RDS Subnet Group
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "app-db-subnet-group"
  subnet_ids = [
    aws_subnet.public_subnet_a.id,
    aws_subnet.public_subnet_b.id
  ]
}

# Create RDS Instance
resource "aws_db_instance" "app_db" {
  allocated_storage      = 20
  engine                 = "mysql"
  instance_class         = "db.t3.micro"
  db_name                = "employee_db"
  username               = "admin"
  password               = var.db_instance_master_password
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.web_security_group.id]
  skip_final_snapshot = true # Set this to false to ensure a snapshot is taken

}

# Create S3 Buckets
resource "aws_s3_bucket" "photo_bucket" {
  bucket = var.photo_bucket_name

}


# Create DynamoDB Table
resource "aws_dynamodb_table" "employees" {
  name         = "Employees"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "EmployeeID"
  attribute {
    name = "EmployeeID"
    type = "S"
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

# Attach a policy to the IAM Role
resource "aws_iam_role_policy_attachment" "instance_role_policy_attachment" {
  role       = aws_iam_role.instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# Create IAM Instance Profile
resource "aws_iam_instance_profile" "instance_role_profile" {
  name = "instance-role-profile"
  role = aws_iam_role.instance_role.name
}

# Create EC2 Instance for RDS App
resource "aws_instance" "rds_app_instance" {
  ami                    = "ami-0a31f06d64a91614b" 
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet_a.id
  vpc_security_group_ids = [aws_security_group.web_security_group.id]
  iam_instance_profile   = aws_iam_instance_profile.instance_role_profile.name

  depends_on = [aws_db_instance.app_db] # Add dependency on RDS instance

  user_data = <<-EOF
              #!/bin/bash -ex

              # Set environment variables
              export SUB_PHOTOS_BUCKET="${var.photo_bucket_name}"
              export SUB_DATABASE_HOST="${aws_db_instance.app_db.address}"
              export SUB_DATABASE_USER="admin"
              export SUB_DATABASE_PASSWORD="${var.db_instance_master_password}"

              wget https://aws-tc-largeobjects.s3-us-west-2.amazonaws.com/DEV-AWS-MO-GCNv2/FlaskApp.zip
              unzip FlaskApp.zip
              cd FlaskApp/
              ./install_launch.sh
              EOF
}


# Create EC2 Instance for DynamoDB App
resource "aws_instance" "dynamo_app_instance" {
  ami                    = "ami-0a31f06d64a91614b" 
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet_a.id
  vpc_security_group_ids = [aws_security_group.web_security_group.id]
  iam_instance_profile   = aws_iam_instance_profile.instance_role_profile.name

  depends_on = [aws_db_instance.app_db] # Add dependency on RDS instance

  user_data = <<-EOF

              # Set environment variables

              export SUB_PHOTOS_BUCKET="${var.photo_bucket_name}"

              #!/bin/bash -ex
              wget https://aws-tc-largeobjects.s3-us-west-2.amazonaws.com/DEV-AWS-MO-GCNv2/FlaskApp.zip
              unzip FlaskApp.zip
              cd FlaskApp/
              ./install_launch_dynamo.sh
              EOF
}







