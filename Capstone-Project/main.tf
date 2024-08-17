
provider "aws" {
  region = var.aws_region
}

# Reference the default VPC
data "aws_vpc" "default" {
  default = true
}

data "http" "my_ip" {
  url = "http://checkip.amazonaws.com"
}

#key pair
#ssh-keygen -t rsa -b 4096 -f ~/.ssh/my-aws-key
resource "aws_key_pair" "my_key_pair" {
  key_name   = "my-aws-key"
  public_key = file("~/.ssh/my-aws-key.pub")
}

# Reference the default subnets in ${var.aws_region}a and ${var.aws_region}c
data "aws_subnet" "default_subnet_a" {
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

data "aws_subnet" "default_subnet_c" {
  filter {
    name   = "availabilityZone"
    values = ["${var.aws_region}c"]
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

  #http
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #mysql
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #streamlit
  ingress {
    from_port   = 8501
    to_port     = 8501
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #https
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow your ip to connect EC2s
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.my_ip.body)}/32"]
  }

  # Allow SSH access from AWS EC2 Instance Connect IP ranges
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [
      "3.16.146.0/29",  # Example AWS IP ranges, check the latest IP ranges from AWS
    ]
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

resource "aws_security_group" "internal_sg" {
  vpc_id = data.aws_vpc.default.id

  # Allow internal communication within the VPC
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    # cidr_blocks = [data.aws_vpc.default.cidr_block, "${chomp(data.http.my_ip.body)}/32"] # Lambda VPC Config Needs.
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create RDS Instance in the default subnets
resource "aws_db_instance" "app_db" {
  allocated_storage      = 20
  engine                 = "mysql"
  instance_class         = "db.t3.micro"
  db_name                = "employees"
  username               = "admin"
  password               = var.db_instance_master_password
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.internal_sg.id]
  skip_final_snapshot    = true
  publicly_accessible    = true

  ### Backup RDS
  # Conditionally set the backup_retention_period based on var.rds_backup
  backup_retention_period = var.rds_backup ? 7 : 0
  # Conditionally set the backup_window only if backups are enabled
  backup_window = var.rds_backup ? "07:00-09:00" : null

}



resource "null_resource" "run_sql" {
  depends_on = [aws_db_instance.app_db]

  provisioner "local-exec" {
    command = <<EOT
      mysql -h ${aws_db_instance.app_db.address} -u admin -p${var.db_instance_master_password} -e "
        CREATE DATABASE IF NOT EXISTS employees;
        USE employees;

        CREATE TABLE IF NOT EXISTS employees (
            id INT AUTO_INCREMENT PRIMARY KEY,
            name VARCHAR(100),
            age INT,
            email VARCHAR(100)
        );

        INSERT INTO employees (name, age, email) VALUES 
        ('Alice Johnson', 30, 'alice.johnson@example.com'),
        ('Bob Smith', 25, 'bob.smith@example.com'),
        ('Carol Brown', 40, 'carol.brown@example.com');
      "
    EOT
  }
}

resource "aws_s3_bucket" "output_bucket" {
  bucket = var.output_bucket_name # New S3 bucket

  versioning { #ignore Argument is deprecated warning.
    enabled = true
  }
  force_destroy = true
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

# Attach SSM Parameter Store Permissions Policy
resource "aws_iam_role_policy_attachment" "instance_role_ssm_policy_attachment" {
  role       = aws_iam_role.instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}

# Create IAM Instance Profile
resource "aws_iam_instance_profile" "instance_role_profile" {
  name = "instance-role-profile"
  role = aws_iam_role.instance_role.name
}


resource "aws_ssm_parameter" "db_host" {
  name  = "/myapp/db_host"
  type  = "String"
  value = aws_db_instance.app_db.address
}

resource "aws_ssm_parameter" "output_bucket" {
  name  = "/myapp/output_bucket"
  type  = "String"
  value = var.output_bucket_name
}

resource "aws_ssm_parameter" "db_password" {
  name  = "/myapp/db_password"
  type  = "SecureString"
  value = var.db_instance_master_password
}



resource "aws_ssm_parameter" "invoke_url" {
  name       = "/myapp/invoke_url"
  type       = "String"
  value      = aws_api_gateway_deployment.api_deployment.invoke_url
  depends_on = [aws_api_gateway_deployment.api_deployment]
}

# Create IAM role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "lambda_s3_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Attach policies to the IAM role
resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda_s3_policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "rds:DescribeDBInstances",
          "rds:Connect",
          "s3:GetObject",
          "execute-api:Invoke",
        ],
        Effect = "Allow",

        Resource = "*"
      }
    ]
  })
}


# Create Lambda function with reserved concurrency for autoscaling
resource "aws_lambda_function" "get_api_lambda" {
  function_name = "get_api_lambda"
  role          = aws_iam_role.lambda_role.arn
  handler       = "get_api_lambda.lambda_handler"
  runtime       = "python3.11"
  filename      = "functions/lambda_function.zip"


  timeout = 35


  environment {
    variables = {
      db_host     = aws_db_instance.app_db.address
      db_password = var.db_instance_master_password
    }
  }
  #  vpc_config {
  #   subnet_ids = [ data.aws_subnet.default_subnet_a.id,data.aws_subnet.default_subnet_a.id ]
  #   security_group_ids = [ aws_security_group.internal_sg.id ]
  # }
}

# Create Lambda function with reserved concurrency for autoscaling
resource "aws_lambda_function" "post_api_lambda" {
  function_name = "post_api_lambda"
  role          = aws_iam_role.lambda_role.arn
  handler       = "post_api_lambda.lambda_handler"
  runtime       = "python3.11"
  filename      = "functions/lambda_function.zip"

  timeout = 35


  environment {
    variables = {
      db_host     = aws_db_instance.app_db.address
      db_password = var.db_instance_master_password
    }
  }
  # vpc_config {
  #   subnet_ids = [ data.aws_subnet.default_subnet_a.id,data.aws_subnet.default_subnet_a.id ]
  #   security_group_ids = [ aws_security_group.internal_sg.id ]

  # }
}

# Create Lambda function with reserved concurrency for autoscaling
resource "aws_lambda_function" "delete_api_lambda" {
  function_name = "delete_api_lambda"
  role          = aws_iam_role.lambda_role.arn
  handler       = "delete_api_lambda.lambda_handler"
  runtime       = "python3.11"
  filename      = "functions/lambda_function.zip"



  timeout = 35

  environment {
    variables = {
      db_host     = aws_db_instance.app_db.address
      db_password = var.db_instance_master_password
    }
  }
  #  vpc_config {
  #   subnet_ids = [ data.aws_subnet.default_subnet_a.id,data.aws_subnet.default_subnet_a.id ]
  #   security_group_ids = [ aws_security_group.internal_sg.id ]
  # }
}

# Create API Gateway
resource "aws_api_gateway_rest_api" "api_gateway" {
  name        = "LambdaAPI"
  description = "API Gateway for Lambda functions"
  endpoint_configuration {
    types = ["REGIONAL"]
  }

}

resource "aws_api_gateway_resource" "get_resource" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  parent_id   = aws_api_gateway_rest_api.api_gateway.root_resource_id
  path_part   = "get"

}

resource "aws_api_gateway_resource" "post_resource" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  parent_id   = aws_api_gateway_rest_api.api_gateway.root_resource_id
  path_part   = "post"
}

resource "aws_api_gateway_resource" "delete_resource" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  parent_id   = aws_api_gateway_rest_api.api_gateway.root_resource_id
  path_part   = "delete"
}


# Define GET method for the GET resource
resource "aws_api_gateway_method" "get_method" {
  rest_api_id   = aws_api_gateway_rest_api.api_gateway.id
  resource_id   = aws_api_gateway_resource.get_resource.id
  http_method   = "GET"
  authorization = "NONE"

}



# Integration for GET Lambda
resource "aws_api_gateway_integration" "get_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api_gateway.id
  resource_id             = aws_api_gateway_resource.get_resource.id
  http_method             = aws_api_gateway_method.get_method.http_method
  integration_http_method = "GET"
  type                    = "AWS"
  uri                     = aws_lambda_function.get_api_lambda.invoke_arn

}



resource "aws_api_gateway_integration_response" "get_integration_response" {
  depends_on = [aws_api_gateway_integration.get_integration]
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  resource_id = aws_api_gateway_resource.get_resource.id
  http_method = aws_api_gateway_method.get_method.http_method
  status_code = "200"

  # response_templates = {
  #   "application/json" = "Empty"
  # }

  # No response_templates block, so the response body will be empty
}

# Deploy the API
resource "aws_api_gateway_deployment" "api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  stage_name  = "prod"
  depends_on = [ aws_api_gateway_integration.get_integration]

}

# ADD Load Balancer
###################
# Create a target group for the Streamlit application
resource "aws_alb" "app_lb" {
  name               = "app-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web_security_group.id]
  subnets            = [data.aws_subnet.default_subnet_a.id, data.aws_subnet.default_subnet_c.id]

  enable_deletion_protection = false
  enable_http2               = true

  tags = {
    Name = "app-load-balancer"
  }
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_alb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Healthy"
      status_code  = "200"
    }
  }
}

resource "aws_alb_target_group" "app_target_group" {
  name     = "app-target-group"
  port     = 8501
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

resource "aws_alb_listener_rule" "default" {
  listener_arn = aws_alb_listener.http.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.app_target_group.arn
  }

  condition {  
    path_pattern {
      values = ["*"]
    }
  
  }
}

resource "aws_launch_configuration" "app_lc" {
  name          = "app-launch-configuration3"
  image_id       = "ami-003932de22c285676"  # Use your AMI ID
  instance_type  = "t2.micro"
  key_name       = aws_key_pair.my_key_pair.key_name
  security_groups = [aws_security_group.web_security_group.id]
  iam_instance_profile   = aws_iam_instance_profile.instance_role_profile.name
  depends_on = [ aws_ssm_parameter.db_host,aws_ssm_parameter.db_password,aws_ssm_parameter.output_bucket,aws_ssm_parameter.invoke_url ]
  lifecycle {
    create_before_destroy = true
  }

  user_data = <<-EOF
#!/bin/bash -ex

# Update and install dependencies
sudo apt-get update
sudo apt-get install -y python3-pip python3-dev nginx awscli  mariadb-client

# Install Streamlit and MySQL connector
pip3 install streamlit mysql-connector-python boto3 botocore

# Download Streamlit app
wget https://raw.githubusercontent.com/mustafaksr/aws-solution-architect-knowledge/main/Capstone-Project/app/app.py
mv app.py /home/ubuntu/app.py

# Fetch parameters from AWS Systems Manager Parameter Store
export API_BASE_URL="$(aws ssm get-parameter --name "/myapp/invoke_url" --query "Parameter.Value" --region "${var.aws_region}" --output text)"

# Append variables to bashrc to make them available for new CLI sessions
echo "export API_BASE_URL=\"$(aws ssm get-parameter --name "/myapp/invoke_url" --query "Parameter.Value" --region "${var.aws_region}" --output text)\"" >> ~/.bashrc

# Reload the bashrc to apply the changes
source ~/.bashrc

# Configure Nginx
echo 'server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://localhost:8501;  # Default port for Streamlit
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}' | sudo tee /etc/nginx/sites-available/streamlit > /dev/null


# Enable Nginx configuration
sudo ln -sf /etc/nginx/sites-available/streamlit /etc/nginx/sites-enabled/

sudo systemctl restart nginx

# Run Streamlit app
streamlit run /home/ubuntu/app.py --server.port 8501 &

EOF
}

resource "aws_autoscaling_group" "app_asg" {
  launch_configuration = aws_launch_configuration.app_lc.id
  min_size             = 2
  max_size             = 3
  desired_capacity     = 2
  vpc_zone_identifier  = [data.aws_subnet.default_subnet_a.id, data.aws_subnet.default_subnet_c.id]
  health_check_type    = "ELB"
  health_check_grace_period = 300
  
  // Use target_group_arns for ALBs
  target_group_arns = [aws_alb_target_group.app_target_group.arn]  
  
  tag {
    key                 = "Name"
    value               = "bstreamlit-app-instancear"
    propagate_at_launch = true
  }
}


resource "aws_autoscaling_policy" "scale_out" {
  name                   = "scale-out"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.app_asg.name
}

resource "aws_autoscaling_policy" "scale_in" {
  name                   = "scale-in"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.app_asg.name
}

resource "aws_cloudwatch_metric_alarm" "scale_out_alarm" {
  alarm_name          = "scale-out-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 70
  alarm_actions       = [aws_autoscaling_policy.scale_out.arn]
}

resource "aws_cloudwatch_metric_alarm" "scale_in_alarm" {
  alarm_name          = "scale-in-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 30
  alarm_actions       = [aws_autoscaling_policy.scale_in.arn]
}



###################


output "instructions" {
  value = "visit Capstone-Project/README.md to deploy api manually from aws api gateway console."
}

output "host_db" {

  value = aws_db_instance.app_db.address

}

output "api_url" {
  value = aws_api_gateway_deployment.api_deployment.invoke_url
}


output "alb_url" {
  value = "http://${aws_alb.app_lb.dns_name}"
  description = "The URL of the ALB"
}

output "local_ip" {
  description = "Local PC External IP"
  value = "${chomp(data.http.my_ip.body)}"
}