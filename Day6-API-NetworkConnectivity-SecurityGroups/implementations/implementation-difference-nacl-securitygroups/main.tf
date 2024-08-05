provider "aws" {
  region = var.aws_region
}

# Create a VPC
resource "aws_vpc" "example_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
}

# Key Pair
resource "aws_key_pair" "my_key_pair" {
  key_name   = "my-aws-key"
  public_key = file("~/.ssh/my-aws-key.pub")
}

# Create a Public Subnet
resource "aws_subnet" "public_subnet_sg" {
  vpc_id                  = aws_vpc.example_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true
}

# Create a Public Subnet
resource "aws_subnet" "public_subnet_nacl_allow" {
  vpc_id                  = aws_vpc.example_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = true
}

# Create a Public Subnet
resource "aws_subnet" "public_subnet_nacl_deny" {
  vpc_id                  = aws_vpc.example_vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "${var.aws_region}c"
  map_public_ip_on_launch = true
}

# Create an Internet Gateway
resource "aws_internet_gateway" "example_igw" {
  vpc_id = aws_vpc.example_vpc.id
}

# Create a Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.example_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.example_igw.id
  }
}

# Associate the Route Table with the Public Subnet
resource "aws_route_table_association" "public_rt_assoc" {
  subnet_id      = aws_subnet.public_subnet_nacl_allow.id
  route_table_id = aws_route_table.public_rt.id
}

# Associate the Route Table with the Public Subnet
resource "aws_route_table_association" "public_rt_assoc_deny" {
  subnet_id      = aws_subnet.public_subnet_nacl_deny.id
  route_table_id = aws_route_table.public_rt.id
}

# Associate the Route Table with the Public Subnet
resource "aws_route_table_association" "public_rt_assoc_sg" {
  subnet_id      = aws_subnet.public_subnet_sg.id
  route_table_id = aws_route_table.public_rt.id
}

# Create a Security Group
resource "aws_security_group" "example_sg" {
  vpc_id = aws_vpc.example_vpc.id

  # ICMP
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH from anywhere
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic
  }
}




# Create a Network ACL (NACL)
resource "aws_network_acl" "example_nacl_allow" {
  vpc_id = aws_vpc.example_vpc.id

  # Inbound Rules

  ingress {
    rule_no    = 105
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }
  ingress {
    rule_no    = 106
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  ingress {
    rule_no    = 107
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 22
    to_port    = 22
  }

  ingress {
    rule_no    = 100
    protocol   = "icmp"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  # Outbound Rules
  egress {
    rule_no    = 100
    protocol   = "-1"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }


}



resource "aws_network_acl" "example_nacl_deny" {
  vpc_id = aws_vpc.example_vpc.id

  # Inbound Rules
  ingress {
    rule_no    = 105
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 22
    to_port    = 22
  }



  # Outbound Rules
  egress {
    rule_no    = 100
    protocol   = "-1"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }


}


# Associate the NACL with the Public Subnet
resource "aws_network_acl_association" "public_nacl_allow" {
  subnet_id      = aws_subnet.public_subnet_nacl_allow.id
  network_acl_id = aws_network_acl.example_nacl_allow.id
}

# Associate the NACL with the Public Subnet
resource "aws_network_acl_association" "public_nacl_deny" {
  subnet_id      = aws_subnet.public_subnet_nacl_deny.id
  network_acl_id = aws_network_acl.example_nacl_deny.id
}

# Create an EC2 Instance with security group
resource "aws_instance" "example_instance_sg" {
  ami                         = "ami-003932de22c285676" # Ubuntu
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_subnet_sg.id
  key_name                    = aws_key_pair.my_key_pair.key_name
  vpc_security_group_ids      = [aws_security_group.example_sg.id] # Use vpc_security_group_ids instead of security_groups
  associate_public_ip_address = true
  tags = {
    Name = "SecurityGroup-Example"
  }

}

# Create an EC2 Instance with nacl
resource "aws_instance" "example_instance_nacl" {
  ami                         = "ami-003932de22c285676" # Ubuntu
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_subnet_nacl_allow.id
  key_name                    = aws_key_pair.my_key_pair.key_name
  vpc_security_group_ids      = [aws_security_group.example_sg.id]
  associate_public_ip_address = true
  tags = {
    Name = "NACL-Example-allow-icmp"
  }
}

# Create an EC2 Instance with nacl
resource "aws_instance" "example_instance_nacl_deny" {
  ami                         = "ami-003932de22c285676" # Ubuntu
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_subnet_nacl_deny.id
  key_name                    = aws_key_pair.my_key_pair.key_name
  vpc_security_group_ids      = [aws_security_group.example_sg.id]
  associate_public_ip_address = true
  tags = {
    Name = "NACL-Example-deny-icmp"
  }
}

# Output the sg instance's public IP
output "instance_sg_public_ip" {
  value       = aws_instance.example_instance_sg.public_ip
  description = "Security Group EC2 External IP"
}

# Output the nacl instance's public IP
output "instance_nacl_allow_public_ip" {
  value       = aws_instance.example_instance_nacl.public_ip
  description = "Network ACL Allow EC2 External IP"

}

# Output the nacl instance's public IP
output "instance_nacl_deny_public_ip" {
  value       = aws_instance.example_instance_nacl.public_ip
  description = "Network ACL Deny EC2 External IP"

}