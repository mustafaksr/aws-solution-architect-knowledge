provider "aws" {
  region = var.aws_region
}

# Reference the default VPC
data "aws_vpc" "default" {
  default = true
}

# Reference the default subnets in us-east-2a and us-east-2b
data "aws_subnet" "default_subnet_a" {
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

data "aws_subnet" "default_subnet_c" {
  filter {
    name   = "availabilityZone"
    values = ["us-east-2c"]
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




#mysql
ingress {
    from_port   = 3306
    to_port     = 3306
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

# Use existing default subnets for RDS Subnet Group
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "app-db-subnet-group"
  subnet_ids = [data.aws_subnet.default_subnet_a.id, data.aws_subnet.default_subnet_c.id]

  


}

# Create RDS Instance in the default subnets
resource "aws_db_instance" "app_db" {
  allocated_storage      = 20
  engine                 = "mysql"
  instance_class         = "db.t3.micro"
  db_name                = "tableau"
  username               = "admin"
  password               = var.db_instance_master_password
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.web_security_group.id]
  skip_final_snapshot    = true
  publicly_accessible = true
}



resource "aws_ssm_parameter" "db_host" {
  name  = "/myapp/db_host"
  type  = "String"
  value = aws_db_instance.app_db.address
}


resource "aws_ssm_parameter" "db_password" {
  name  = "/myapp/db_password"
  type  = "SecureString"
  value = var.db_instance_master_password
}



output "db_address" {
  value = aws_db_instance.app_db.address
}

output "db_password" {
  value = var.db_instance_master_password
}


