provider "aws" {
  region = var.aws_region
}

resource "aws_key_pair" "my_key" {
  key_name   = "my-aws-key"
  public_key = file("~/.ssh/my-aws-key.pub")
}

# VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Internet Gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
}

# Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true
}

# Private Subnet
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "${var.aws_region}a"
}

# NAT Gateway (requires an Elastic IP)
resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "my_nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id
}

# Route Table for Public Subnet
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }
}

resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# Route Table for Private Subnet
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.my_nat_gateway.id
  }
}

resource "aws_route_table_association" "private_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}

# Security Group for SSH, ICMP, HTTP, and HTTPS
resource "aws_security_group" "web_sg" {
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security Group for private
resource "aws_security_group" "private_sg" {
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.private_subnet.cidr_block]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.private_subnet.cidr_block]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance in Public Subnet
resource "aws_instance" "public_instance-1" {
  ami             = "ami-003932de22c285676" 
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.public_subnet.id
  key_name        = aws_key_pair.my_key.key_name
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "Public-Instance-1"
  }
}

# EC2 Instance in Public Subnet
resource "aws_instance" "public_instance-2" {
  ami             = "ami-003932de22c285676" 
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.public_subnet.id
  key_name        = aws_key_pair.my_key.key_name
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "Public-Instance-2"
  }
}


# EC2 Instance in Private Subnet
resource "aws_instance" "private_instance-1" {
  ami             = "ami-003932de22c285676" 
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.private_subnet.id
  key_name        = aws_key_pair.my_key.key_name
  vpc_security_group_ids = [aws_security_group.private_sg.id]

  tags = {
    Name = "Private-Instance-1"
  }
}

# EC2 Instance in Private Subnet
resource "aws_instance" "private_instance-2" {
  ami             = "ami-003932de22c285676" 
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.private_subnet.id
  key_name        = aws_key_pair.my_key.key_name
  vpc_security_group_ids = [aws_security_group.private_sg.id]

  tags = {
    Name = "Private-Instance-2"
  }
}

# Can't achieve to create EC2 Instance Connect Endpoint with terrafrom. It needs to create manually from aws Endpoints.
# resource "aws_ec2_instance_connect_endpoint" "example" {
#   subnet_id = aws_subnet.private_subnet.id
# }

# Outputs for EC2 Instance IPs
output "public_instance_1_ip" {
  value = aws_instance.public_instance-1.public_ip
  description = "Public IP address of the first public EC2 instance"
}

output "public_instance_2_ip" {
  value = aws_instance.public_instance-2.public_ip
  description = "Public IP address of the second public EC2 instance"
}

# Outputs for EC2 Instance IPs
output "public_instance_1_ip_internal" {
  value = aws_instance.public_instance-1.private_ip
  description = "Private IP address of the first public EC2 instance"
}

output "public_instance_2_ip_internal" {
  value = aws_instance.public_instance-2.private_ip
  description = "Private IP address of the second public EC2 instance"
}

output "private_instance_1_ip" {
  value = aws_instance.private_instance-1.private_ip
  description = "Private IP address of the first private EC2 instance"
}

output "private_instance_2_ip" {
  value = aws_instance.private_instance-2.private_ip
  description = "Private IP address of the second private EC2 instance"
}

output "aws_ec2_instance_connect_endpoint_subnet_id" {
  value = aws_subnet.private_subnet.id
  description = "EC2 Instance Connect Subnet id."
}