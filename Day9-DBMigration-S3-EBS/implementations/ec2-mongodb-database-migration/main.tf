provider "aws" {
  region = var.aws_region
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
    values = ["us-east-2a"]
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


  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # MONGODB
  ingress {
    from_port   = 27017
    to_port     = 27017
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

# Create EC2 Instance for MongoDB
resource "aws_instance" "mongo_instance" {
  ami                    = "ami-003932de22c285676" # Replace with an appropriate AMI ID for MongoDB
  instance_type          = "t2.micro"
  subnet_id              = data.aws_subnet.default_subnet.id
  vpc_security_group_ids = [aws_security_group.web_security_group.id]
  iam_instance_profile   = aws_iam_instance_profile.instance_role_profile.name
  key_name               = aws_key_pair.my_key_pair.key_name

  user_data = <<-EOF
#!/bin/bash -ex

# Update and install MongoDB
sudo apt-get update
sudo apt-get install -y gnupg curl
curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | \
   sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg --dearmor
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
sudo apt-get update
sudo apt-get install -y mongodb-org

# Start MongoDB
sudo systemctl start mongod
sudo systemctl enable mongod

# Configure MongoDB to listen on all IP addresses
sudo sed -i '/^net:/,/^  bindIp:/ {s/^  bindIp:.*/  bindIp: 0.0.0.0/}' /etc/mongod.conf

# Restart MongoDB to apply changes
sudo systemctl restart mongod
EOF


  tags = {
    Name = "MongoDB-Instance"
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


# Outputs
output "mongodb_uri" {
  value = "${aws_instance.mongo_instance.public_ip}"
}

output "mongodb_password" {
  value = var.mongodb_password
}

output "mongodb_user" {
  value = "admin"
}