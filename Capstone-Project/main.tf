
provider "aws" {
  region = var.aws_region
}

# Reference the default VPC
data "aws_vpc" "default" {
  default = true
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

resource "aws_security_group" "internal_sg" {
  vpc_id = data.aws_vpc.default.id

  # Allow internal communication within the VPC
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    # cidr_blocks = [data.aws_vpc.default.cidr_block]
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
  name  = "/myapp/invoke_url"
  type  = "String"
  value = aws_api_gateway_deployment.api_deployment.invoke_url
  depends_on = [ aws_api_gateway_deployment.api_deployment ]
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

  # Set reserved concurrency (optional, max concurrency can be set)
  # reserved_concurrent_executions = 10
  # vpc_config {
  #   subnet_ids         = [data.aws_subnet.default_subnet_a.id, data.aws_subnet.default_subnet_c.id]
  #   security_group_ids = [aws_security_group.internal_sg.id]
  # }
  environment {
    variables = {
      db_host     = aws_db_instance.app_db.address
      db_password = var.db_instance_master_password
    }
  }
}

# Create Lambda function with reserved concurrency for autoscaling
resource "aws_lambda_function" "post_api_lambda" {
  function_name = "post_api_lambda"
  role          = aws_iam_role.lambda_role.arn
  handler       = "post_api_lambda.lambda_handler"
  runtime       = "python3.11"
  filename      = "functions/lambda_function.zip"

  timeout = 35

  # Set reserved concurrency (optional, max concurrency can be set)
  # reserved_concurrent_executions = 10
  # vpc_config {
  #   subnet_ids         = [data.aws_subnet.default_subnet_a.id, data.aws_subnet.default_subnet_c.id]
  #   security_group_ids = [aws_security_group.internal_sg.id]
  # }
  environment {
    variables = {
      db_host     = aws_db_instance.app_db.address
      db_password = var.db_instance_master_password
    }
  }
}

# Create Lambda function with reserved concurrency for autoscaling
resource "aws_lambda_function" "delete_api_lambda" {
  function_name = "delete_api_lambda"
  role          = aws_iam_role.lambda_role.arn
  handler       = "delete_api_lambda.lambda_handler"
  runtime       = "python3.11"
  filename      = "functions/lambda_function.zip"



  timeout = 35

  # Set reserved concurrency (optional, max concurrency can be set)
  # reserved_concurrent_executions = 10
  # vpc_config {
  #   subnet_ids         = [data.aws_subnet.default_subnet_a.id, data.aws_subnet.default_subnet_c.id]
  #   security_group_ids = [aws_security_group.internal_sg.id]
  # }
  environment {
    variables = {
      db_host     = aws_db_instance.app_db.address
      db_password = var.db_instance_master_password
    }
  }
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

# # Define POST method for the POST resource
# resource "aws_api_gateway_method" "post_method" {
#   rest_api_id   = aws_api_gateway_rest_api.api_gateway.id
#   resource_id   = aws_api_gateway_resource.post_resource.id
#   http_method   = "POST"
#   authorization = "NONE"
# }

# # Define DELETE method for the DELETE resource
# resource "aws_api_gateway_method" "delete_method" {
#   rest_api_id   = aws_api_gateway_rest_api.api_gateway.id
#   resource_id   = aws_api_gateway_resource.delete_resource.id
#   http_method   = "DELETE"
#   authorization = "NONE"
# }


# resource "aws_api_gateway_method_response" "get_method_response" {
#   rest_api_id = aws_api_gateway_rest_api.api_gateway.id
#   resource_id = aws_api_gateway_resource.get_resource.id
#   http_method = aws_api_gateway_method.get_method.http_method
#   status_code = "200"  # The status code you expect


#   response_models = {
#     "application/json" = "Empty"


# }
# }

# Integration for GET Lambda
resource "aws_api_gateway_integration" "get_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api_gateway.id
  resource_id             = aws_api_gateway_resource.get_resource.id
  http_method             = aws_api_gateway_method.get_method.http_method
  integration_http_method = "GET"
  type                    = "AWS"
  uri                     = aws_lambda_function.get_api_lambda.invoke_arn
  
}



# resource "aws_api_gateway_integration_response" "get_integration_response" {
#   rest_api_id = aws_api_gateway_rest_api.api_gateway.id
#   resource_id = aws_api_gateway_resource.get_resource.id
#   http_method = aws_api_gateway_method.get_method.http_method
#   status_code = "200"

#   # response_templates = {
#   #   "application/json" = "Empty"
#   # }

#   # No response_templates block, so the response body will be empty
# }


# # Integration for POST Lambda
# resource "aws_api_gateway_integration" "post_integration" {
#   rest_api_id             = aws_api_gateway_rest_api.api_gateway.id
#   resource_id             = aws_api_gateway_resource.post_resource.id
#   http_method             = aws_api_gateway_method.post_method.http_method
#   integration_http_method = "POST"
#   type                    = "AWS"
#   uri                     = aws_lambda_function.post_api_lambda.invoke_arn
# }

# # Integration for DELETE Lambda
# resource "aws_api_gateway_integration" "delete_integration" {
#   rest_api_id             = aws_api_gateway_rest_api.api_gateway.id
#   resource_id             = aws_api_gateway_resource.delete_resource.id
#   http_method             = aws_api_gateway_method.delete_method.http_method
#   integration_http_method = "DELETE"
#   type                    = "AWS"
#   uri                     = aws_lambda_function.delete_api_lambda.invoke_arn
# }



# Deploy the API
resource "aws_api_gateway_deployment" "api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  stage_name  = "prod"
  # depends_on = [ aws_api_gateway_integration.get_integration,aws_api_gateway_integration.post_integration,aws_api_gateway_integration.delete_integration ]
 
}




# Create EC2 Instance for RDS App
resource "aws_instance" "rds_app_instance" {
  ami                    = "ami-003932de22c285676"
  instance_type          = "t2.micro"
  subnet_id              = data.aws_subnet.default_subnet_a.id
  vpc_security_group_ids = [aws_security_group.web_security_group.id]
  iam_instance_profile   = aws_iam_instance_profile.instance_role_profile.name
  key_name               = aws_key_pair.my_key_pair.key_name

  depends_on = [aws_db_instance.app_db, aws_ssm_parameter.invoke_url, aws_ssm_parameter.db_password,aws_ssm_parameter.db_host, aws_ssm_parameter.output_bucket]
  tags = {
    Name = "Streamlit APP" # This is the display name
  }
  user_data = <<-EOF
#!/bin/bash -ex

# Update and install dependencies
sudo apt-get update
sudo apt-get install -y python3-pip python3-dev nginx awscli  mariadb-client

# Install Streamlit and MySQL connector
pip3 install streamlit mysql-connector-python boto3

# Download Streamlit app
wget https://github.com/mustafaksr/aws-solution-architect-knowledge/raw/524a306f4912fd05adc82b2eaa0ad44e8d9a4c25/Capstone-Project/app/app.py
mv app.py /home/ubuntu/app.py

# Fetch parameters from AWS Systems Manager Parameter Store
export DATABASE_HOST=$(aws ssm get-parameter --name "/myapp/db_host" --query "Parameter.Value" --region ${var.aws_region} --output text)
export DATABASE_PASSWORD=$(aws ssm get-parameter --name "/myapp/db_password" --with-decryption --query "Parameter.Value" --region ${var.aws_region} --output text)
export DATABASE_USER=admin
export OUTPUT_BUCKET_NAME=$(aws ssm get-parameter --name "/myapp/output_bucket" --query "Parameter.Value" --region ${var.aws_region} --output text)

export API_BASE_URL=$(aws ssm get-parameter --name "/myapp/invoke_url" --query "Parameter.Value" --region ${var.aws_region} --output text)

# Create example database and table, and insert sample data
mysql -h $(aws ssm get-parameter --name "/myapp/db_host" --query "Parameter.Value" --region ${var.aws_region} --output text) -u admin -p$(aws ssm get-parameter --name "/myapp/db_password" --with-decryption --query "Parameter.Value" --region ${var.aws_region} --output text) -e "
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

# # Define a new EBS volume
# resource "aws_ebs_volume" "additional_volume" {
#   availability_zone = data.aws_subnet.default_subnet_a.availability_zone # Match the availability zone of the EC2 instance
#   size              = 10                                                 # Size in GB
#   tags = {
#     Name = "Additional-Volume"
#   }
#   depends_on = [aws_instance.rds_app_instance]
# }

# # Attach the EBS volume to the EC2 instance
# resource "aws_volume_attachment" "ebs_attachment" {
#   device_name  = "/dev/sdf" # Device name can vary (e.g., /dev/sdf, /dev/xvdf, etc.)
#   volume_id    = aws_ebs_volume.additional_volume.id
#   instance_id  = aws_instance.rds_app_instance.id
#   force_detach = true # Detach any existing volume before attaching the new one

#   depends_on = [aws_instance.rds_app_instance]

# }

output "host_db" {

  value = aws_db_instance.app_db.address

}

output "api_url" {
  value = aws_api_gateway_deployment.api_deployment.invoke_url
}

output "app_url" {
  value = "http://${aws_instance.rds_app_instance.public_ip}:8501"
}