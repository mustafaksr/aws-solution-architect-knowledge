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
  # Streamlit
  ingress {
    from_port   = 8501
    to_port     = 8501
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

# Create Amazon DocumentDB Cluster
resource "aws_docdb_cluster" "docdb_cluster" {
  cluster_identifier      = "docdb-cluster"
  engine                  = "docdb"
  master_username         = var.docdb_cluster_user
  master_password         = var.docdb_cluster_password
  backup_retention_period = 5
  preferred_backup_window = "07:00-09:00"
  skip_final_snapshot = true
  vpc_security_group_ids = [aws_security_group.web_security_group.id]
}

resource "aws_docdb_cluster_instance" "docdb_instance" {
  identifier          = "docdb-instance"
  cluster_identifier  = aws_docdb_cluster.docdb_cluster.id
  instance_class      = "db.t3.medium"

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
resource "aws_iam_role_policy_attachment" "instance_role_policy_attachment" {
  role       = aws_iam_role.instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "instance_role_docdb_policy_attachment" {
  role       = aws_iam_role.instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDocDBFullAccess"
}

resource "aws_iam_role_policy_attachment" "instance_role_ssm_policy_attachment" {
  role       = aws_iam_role.instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}

# Create IAM Instance Profile
resource "aws_iam_instance_profile" "instance_role_profile" {
  name = "instance-role-profile"
  role = aws_iam_role.instance_role.name
}

# Create EC2 Instance for Streamlit App
resource "aws_instance" "streamlit_app_instance" {
  ami                    = "ami-003932de22c285676"
  instance_type          = "t2.micro"
  subnet_id              = data.aws_subnet.default_subnet.id
  vpc_security_group_ids = [aws_security_group.web_security_group.id]
  iam_instance_profile   = aws_iam_instance_profile.instance_role_profile.name
  key_name               = aws_key_pair.my_key_pair.key_name
  depends_on = [aws_docdb_cluster_instance.docdb_instance] 
  user_data = <<-EOF
#!/bin/bash -ex

# Update and install dependencies
sudo apt-get update
sudo apt-get install -y python3-pip python3-dev nginx awscli

# Install Streamlit, Boto3, and Pymongo
pip3 install streamlit boto3 pymongo

# Create Streamlit app
cat <<'EOL' > /home/ubuntu/app.py
import streamlit as st
import boto3
import pymongo
from bson import ObjectId
from PIL import Image
import os
import subprocess


# Set AWS region and S3 bucket name
AWS_REGION = 'us-east-2'
S3_BUCKET = 'my-app-images-bucket-8re7te4'

# Use subprocess to download the CA certificate
try:
    subprocess.run(
        ["wget", "https://truststore.pki.rds.amazonaws.com/global/global-bundle.pem"],
        check=True
    )
    print(f"CA certificate downloaded successfully")
except subprocess.CalledProcessError as e:
    print(f"Failed to download CA certificate: {e}")
    exit(1)

DOCDB_URI="mongodb://${var.docdb_cluster_user}:${var.docdb_cluster_password}@${aws_docdb_cluster.docdb_cluster.endpoint}:27017/?tls=true&tlsCAFile=global-bundle.pem&retryWrites=false"


# Initialize S3 client
s3 = boto3.client('s3', region_name=AWS_REGION)

# Initialize MongoDB client
client = pymongo.MongoClient(DOCDB_URI)
db = client.image_metadata_db  # Database name
collection = db.images  # Collection name

# Streamlit app layout
st.title("Image Upload and Management App")

# Image upload section
st.header("Upload Image")
image_name = st.text_input("Image Name")
image_description = st.text_area("Image Description")
uploaded_image = st.file_uploader("Choose an image", type=["jpg", "jpeg", "png"])

if st.button("Upload Image"):
    if image_name and image_description and uploaded_image:
        # Upload image to S3
        s3_key = f"images/{image_name}"
        s3.upload_fileobj(uploaded_image, S3_BUCKET, s3_key)
        
        # Get the image URL
        image_url = f"https://{S3_BUCKET}.s3.{AWS_REGION}.amazonaws.com/{s3_key}"
        
        # Store metadata in DocumentDB
        image_record = {
            "name": image_name,
            "description": image_description,
            "url": image_url
        }
        collection.insert_one(image_record)
        
        st.success("Image uploaded and metadata saved successfully!")
    else:
        st.error("Please provide all details and an image.")

# Display uploaded images in a table
st.header("Uploaded Images")

# Retrieve images from DocumentDB
images = list(collection.find())

for image in images:
    st.write(f"**Name:** {image['name']}")
    st.write(f"**Description:** {image['description']}")
    st.image(image['url'], width=200)
    
    if st.button(f"Delete {image['name']}", key=str(image['_id'])):
        # Delete image from S3
        s3.delete_object(Bucket=S3_BUCKET, Key=f"images/{image['name']}")
        
        # Delete metadata from DocumentDB
        collection.delete_one({"_id": ObjectId(image['_id'])})
        
        st.success("Image and metadata deleted successfully!")
        st.experimental_rerun()
EOL

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

# Outputs
output "docdb_cluster_endpoint" {
  value = aws_docdb_cluster.docdb_cluster.endpoint
}

output "s3_bucket_name" {
  value = aws_s3_bucket.images_bucket.bucket
}
