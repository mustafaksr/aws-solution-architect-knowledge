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
  #http
  ingress {
    from_port   = 80
    to_port     = 80
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
  #streamlit
  ingress {
    from_port   = 8501
    to_port     = 8501
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  #ssh
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

# Create DynamoDB Table for Inventory Management
resource "aws_dynamodb_table" "inventory" {
  name         = "Inventory"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "ItemID"

  attribute {
    name = "ItemID"
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

# Attach a policy to the IAM Role to allow DynamoDB access
resource "aws_iam_role_policy_attachment" "instance_role_policy_attachment" {
  role       = aws_iam_role.instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
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

# Create SSM Parameter for DynamoDB Table Name
resource "aws_ssm_parameter" "dynamodb_table_name" {
  name  = "/myapp/dynamodb_table_name"
  type  = "String"
  value = aws_dynamodb_table.inventory.name
}

# Create EC2 Instance for Streamlit App
resource "aws_instance" "streamlit_app_instance" {
  ami                    = "ami-003932de22c285676"
  instance_type          = "t2.micro"
  subnet_id              = data.aws_subnet.default_subnet.id
  vpc_security_group_ids = [aws_security_group.web_security_group.id]
  iam_instance_profile   = aws_iam_instance_profile.instance_role_profile.name
  key_name               = aws_key_pair.my_key_pair.key_name

  user_data = <<-EOF
#!/bin/bash -ex

# Update and install dependencies
sudo apt-get update
sudo apt-get install -y python3-pip python3-dev nginx awscli

# Install Streamlit and Boto3
pip3 install streamlit boto3

# Create Streamlit app
cat <<'EOL' > /home/ubuntu/app.py
import streamlit as st
import boto3
from boto3.dynamodb.conditions import Key

# Initialize DynamoDB client
dynamodb = boto3.resource('dynamodb',region_name='us-east-2')
table = dynamodb.Table('Inventory')

# Function to fetch all items
def fetch_items():
    response = table.scan()
    items = response['Items']
    return items

# Function to add a new item
def add_item(item_id, item_name, quantity):
    table.put_item(
        Item={
            'ItemID': item_id,
            'ItemName': item_name,
            'Quantity': quantity
        }
    )
    st.success("Item added successfully!")

# Streamlit app
st.title("Inventory Management System")

# Display inventory
if st.button("Show Inventory"):
    items = fetch_items()
    for item in items:
        st.write(f"Item ID: {item['ItemID']}, Name: {item['ItemName']}, Quantity: {item['Quantity']}")

# Add new item
with st.form(key='add_item_form'):
    st.subheader("Add New Item")
    item_id = st.text_input("Item ID")
    item_name = st.text_input("Item Name")
    quantity = st.number_input("Quantity", min_value=0)
    submit_button = st.form_submit_button("Add Item")
    
    if submit_button:
        add_item(item_id, item_name, quantity)

EOL

# Fetch parameters from AWS Systems Manager Parameter Store
export DYNAMODB_TABLE_NAME=$(aws ssm get-parameter --name "/myapp/dynamodb_table_name" --query "Parameter.Value" --region us-east-2 --output text)

# Configure Nginx
echo 'server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://localhost:8501;
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

output "dynamodb_table_name" {
  value = aws_dynamodb_table.inventory.name
}
