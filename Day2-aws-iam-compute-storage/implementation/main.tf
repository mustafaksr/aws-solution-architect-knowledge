terraform {
  backend "s3" {
    bucket = "terraform-state-day2-sf48er9gytr"  # Replace with your S3 bucket name
    region = "us-east-2"         # Replace with your AWS region
    key    = "terraform/state/terraform.tfstate" # Organizes the state file under this path
    encrypt        = true                     # Enable server-side encryption of the state file
  }
}

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

data "aws_subnet" "default_subnet_b" {
  filter {
    name   = "availabilityZone"
    values = ["us-east-2b"]
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
  subnet_ids = [data.aws_subnet.default_subnet_a.id, data.aws_subnet.default_subnet_b.id]

  


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
  vpc_security_group_ids = [aws_security_group.web_security_group.id]
  skip_final_snapshot    = true
  publicly_accessible = true
}

resource "aws_s3_bucket" "output_bucket" {
  bucket = var.output_bucket_name  # New S3 bucket
  
  versioning { #ignore Argument is deprecated warning.
    enabled = true
  }
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


# Create EC2 Instance for RDS App
resource "aws_instance" "rds_app_instance" {
  ami                    = "ami-003932de22c285676" 
  instance_type          = "t2.micro"
  subnet_id              = data.aws_subnet.default_subnet_a.id
  vpc_security_group_ids = [aws_security_group.web_security_group.id]
  iam_instance_profile   = aws_iam_instance_profile.instance_role_profile.name
  key_name      = aws_key_pair.my_key_pair.key_name
  
  depends_on = [aws_db_instance.app_db] 
    tags = {
    Name = "SQL"            # This is the display name
  }
user_data = <<-EOF
#!/bin/bash -ex

# Update and install dependencies
sudo apt-get update
sudo apt-get install -y python3-pip python3-dev nginx awscli  mariadb-client

# Install Streamlit and MySQL connector
pip3 install streamlit mysql-connector-python boto3

# Create Streamlit app
cat <<'EOL' > /home/ubuntu/app.py
import streamlit as st
import mysql.connector
import pandas as pd
import os
import boto3
from io import StringIO

# Fetching environment variables
db_host = os.getenv('DATABASE_HOST')
db_user = os.getenv('DATABASE_USER')
db_password = os.getenv('DATABASE_PASSWORD')
db_name = "example_db"  # Replace with your actual database name
s3_bucket_name = os.getenv('OUTPUT_BUCKET_NAME')  # Add an environment variable for the S3 bucket name



# Create a connection to the database
def create_connection():
    connection = mysql.connector.connect(
        host=db_host,
        user=db_user,
        password=db_password,
        database=db_name
    )
    return connection

# Query to fetch data
def fetch_data(query):
    conn = create_connection()
    df = pd.read_sql(query, conn)
    conn.close()
    return df

# Function to insert new data
def insert_data(name, age, email):
    conn = create_connection()
    cursor = conn.cursor()
    try:
        cursor.execute("INSERT INTO example_table (name, age, email) VALUES (%s, %s, %s)", (name, age, email))
        conn.commit()
        st.success("Data inserted successfully!")
    except Exception as e:
        conn.rollback()
        st.error(f"An error occurred: {e}")
    finally:
        cursor.close()
        conn.close()

# Function to save DataFrame to S3 as CSV
def save_to_s3(df, filename, bucket_name):
    csv_buffer = StringIO()
    df.to_csv(csv_buffer, index=False)
    s3_resource = boto3.resource('s3')
    s3_resource.Object(bucket_name, filename).put(Body=csv_buffer.getvalue())
    st.success(f"File '{filename}' saved to S3 bucket '{bucket_name}'")

# Streamlit app
st.title("MySQL Data Viewer and Inserter")

# Query section
query = st.text_area("Enter SQL Query:", "SELECT * FROM example_table LIMIT 10")  # Replace with your actual table
if st.button("Execute Query"):
    try:
        data = fetch_data(query)
        st.write(data)
    except Exception as e:
        st.error(f"An error occurred: {e}")

# Form to add new data
with st.form(key='insert_form'):
    st.subheader("Add New Row")
    name = st.text_input("Name")
    age = st.number_input("Age", min_value=0)
    email = st.text_input("Email")
    submit_button = st.form_submit_button("Add Data")
    
    if submit_button:
        if name and email:
            insert_data(name, age, email)
        else:
            st.error("Please fill in all fields.")
# Save button
if st.button("Save as CSV"):
    data = fetch_data("SELECT * FROM example_table")
    filename = "output.csv"
    if filename:
        s3_bucket_name = "output-bucket-streamlit-fs57ef"
        save_to_s3(data, filename, s3_bucket_name)
    else:
        st.error("Please enter a valid filename.")


EOL

# Fetch parameters from AWS Systems Manager Parameter Store
export DATABASE_HOST=$(aws ssm get-parameter --name "/myapp/db_host" --query "Parameter.Value" --region us-east-2 --output text)
export DATABASE_PASSWORD=$(aws ssm get-parameter --name "/myapp/db_password" --with-decryption --query "Parameter.Value" --region us-east-2 --output text)
export DATABASE_USER=admin
export OUTPUT_BUCKET_NAME=$(aws ssm get-parameter --name "/myapp/output_bucket" --query "Parameter.Value" --region us-east-2 --output text)

# Create example database and table, and insert sample data
mysql -h $(aws ssm get-parameter --name "/myapp/db_host" --query "Parameter.Value" --region us-east-2 --output text) -u admin -p$(aws ssm get-parameter --name "/myapp/db_password" --with-decryption --query "Parameter.Value" --region us-east-2 --output text) -e "
CREATE DATABASE IF NOT EXISTS example_db;
USE example_db;

CREATE TABLE IF NOT EXISTS example_table (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    age INT,
    email VARCHAR(100)
);

INSERT INTO example_table (name, age, email) VALUES 
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

# Define a new EBS volume
resource "aws_ebs_volume" "additional_volume" {
  availability_zone = data.aws_subnet.default_subnet_a.availability_zone  # Match the availability zone of the EC2 instance
  size              = 10  # Size in GB
  tags = {
    Name = "Additional-Volume"
  }
  depends_on = [aws_instance.rds_app_instance] 
}

# Attach the EBS volume to the EC2 instance
resource "aws_volume_attachment" "ebs_attachment" {
  device_name = "/dev/sdf"  # Device name can vary (e.g., /dev/sdf, /dev/xvdf, etc.)
  volume_id   = aws_ebs_volume.additional_volume.id
  instance_id = aws_instance.rds_app_instance.id
  force_detach = true  # Detach any existing volume before attaching the new one

  depends_on = [aws_instance.rds_app_instance] 

}

output "host_db" {

  value = aws_db_instance.app_db.address
  
}



