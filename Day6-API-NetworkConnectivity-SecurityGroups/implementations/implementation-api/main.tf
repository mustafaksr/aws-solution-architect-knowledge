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
  # Flask API
  ingress {
    from_port   = 4000
    to_port     = 4000
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





# Create EC2 Instance for API App
resource "aws_instance" "api_app_instance" {
  ami                    = "ami-003932de22c285676"
  instance_type          = "t2.micro"
  subnet_id              = data.aws_subnet.default_subnet.id
  vpc_security_group_ids = [aws_security_group.web_security_group.id]
  key_name               = aws_key_pair.my_key_pair.key_name

  user_data = <<-EOF
#!/bin/bash

# Update and install nginx
sudo apt-get update
sudo apt-get install -y nginx

# Install and start Docker via Snap
sudo snap install docker
sudo snap start docker

# Number of attempts
max_attempts=7
# Delay between attempts
delay=3

# Function to execute a command with retries
retry_command() {
  local cmd="$1"
  local attempt=1
  while true; do
    echo "Attempt $attempt: $cmd"
    if eval $cmd; then
      echo "Command succeeded"
      break
    else
      echo "Command failed. Retrying in $delay seconds..."
      sleep $delay
      ((attempt++))
      if [ $attempt -gt $max_attempts ]; then
        echo "Command failed after $max_attempts attempts."
        exit 1
      fi
    fi
  done
}

# Execute commands with retries
retry_command "sudo systemctl start snap.docker.dockerd.service"
retry_command "sudo systemctl enable snap.docker.dockerd.service"
retry_command "sudo docker pull mustafakeser/acd_diabetes_api:latest"

# Configure Nginx
echo 'server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://localhost:4000; # API port
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}' | sudo tee /etc/nginx/sites-available/flaskapi > /dev/null

# Enable Nginx configuration
sudo ln -sf /etc/nginx/sites-available/flaskapi /etc/nginx/sites-enabled/
sudo systemctl restart nginx

# Run Docker container in detached mode
sudo docker run --rm -d -p 4000:4000/tcp mustafakeser/acd_diabetes_api:latest

EOF

  tags = {
    Name = "Api-App-Instance"
  }

}



output "visit_app" {
  value = "visit url: http://${aws_instance.api_app_instance.public_ip}:4000 to access app. Make sure startup script finished. Use http scheme for test in swagger - http://${aws_instance.api_app_instance.public_ip}:4000/docs/ .\nYou can check cloud init logs, for startup script, with ec2 ssh using sudo tail -f /var/log/cloud-init-output.log"
}