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

sudo apt-get update
sudo apt-get install gnupg curl
curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | \
   sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg \
   --dearmor
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
sudo apt-get update
sudo apt-get install -y mongodb-org

# Start MongoDB
sudo systemctl start mongod
sudo systemctl enable mongod
sudo systemctl restart mongod

sudo sed -i '/^net:/,/^  bindIp:/ {s/^  bindIp:.*/  bindIp: 0.0.0.0/}' /etc/mongod.conf
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

# Create EC2 Instance for Streamlit App
resource "aws_instance" "streamlit_app_instance" {
  ami                    = "ami-003932de22c285676"
  instance_type          = "t2.micro"
  subnet_id              = data.aws_subnet.default_subnet.id
  vpc_security_group_ids = [aws_security_group.web_security_group.id]
  iam_instance_profile   = aws_iam_instance_profile.instance_role_profile.name
  key_name               = aws_key_pair.my_key_pair.key_name
  depends_on             = [aws_instance.mongo_instance]

  user_data = <<-EOF
#!/bin/bash -ex

# Update and install dependencies
sudo apt-get update
sudo apt-get install -y python3-pip python3-dev nginx awscli

# Install Streamlit, Boto3, and Pymongo
pip3 install streamlit boto3 pymongo pandas

# Create Streamlit app
cat <<'EOL' > /home/ubuntu/app.py
import streamlit as st
import pymongo
import pandas as pd
from bson import ObjectId

# MongoDB connection
MONGO_URI = "mongodb://${aws_instance.mongo_instance.private_ip}:27017/"  # Replace with MongoDB internal IP

# Initialize MongoDB client
client = pymongo.MongoClient(MONGO_URI)
db = client.image_metadata_db  # Database name
collection = db.images  # Collection name

# Streamlit app layout
st.title("MongoDB Data Entry App")

# Text field inputs
st.header("Record Entry")
text_field_1 = st.text_input("Field 1")
text_field_2 = st.text_input("Field 2")
text_field_3 = st.text_input("Field 3")
text_field_4 = st.text_input("Field 4")

if st.button("Submit"):
    if text_field_1 or text_field_2 or text_field_3 or text_field_4:
        record = {
        "field_1": text_field_1 if text_field_1 else None,
        "field_2": text_field_2 if text_field_2 else None,
        "field_3": text_field_3 if text_field_3 else None,
        "field_4": text_field_4 if text_field_4 else None,
    }
        collection.insert_one(record)
        st.success("Record added successfully!")
    else:
        st.error("Please fill out all fields.")

# Display records from MongoDB
st.header("Records")

# Retrieve records from MongoDB
records = list(collection.find())

# Convert records to DataFrame
df = pd.DataFrame(records)

# Display DataFrame in Streamlit
st.write("### Records Table")
st.dataframe(df)

# Edit Record
st.header("Edit Record")
if len(records) > 0:
    # Create a single select with IDs as options
    ids_to_display = {str(record['_id']): record for record in records}
    selected_id = st.selectbox(
        "Select a record to edit",
        options=list(ids_to_display.keys()),
        format_func=lambda x: f"ID: {x} - Field 1: {ids_to_display[x].get('field_1', 'N/A')}"
    )
    
    if selected_id:
        record_to_edit = ids_to_display[selected_id]
        
        # Display fields with current values
        edited_field_1 = st.text_input("Field 1", value=record_to_edit.get('field_1', ''), key='e0')
        edited_field_2 = st.text_input("Field 2", value=record_to_edit.get('field_2', ''), key='e1')
        edited_field_3 = st.text_input("Field 3", value=record_to_edit.get('field_3', ''), key='e2')
        edited_field_4 = st.text_input("Field 4", value=record_to_edit.get('field_4', ''), key='e3')
        
        if st.button("Update Record"):
            # Update record in MongoDB
            update_result = collection.update_one(
                {'_id': ObjectId(selected_id)},
                {'$set': {
                    "field_1": edited_field_1 if edited_field_1 else None,
                    "field_2": edited_field_2 if edited_field_2 else None,
                    "field_3": edited_field_3 if edited_field_3 else None,
                    "field_4": edited_field_4 if edited_field_4 else None,
                }}
            )
            if update_result.matched_count:
                st.success("Record updated successfully!")
            else:
                st.error("Error updating record.")
else:
    st.info("No records available to edit.")

# Multi-select for record deletion
st.header("Delete Records")
if len(records) > 0:
    # Create a multi-select with IDs as options
    ids_to_display = {str(record['_id']): idx for idx, record in enumerate(records)}
    selected_ids = st.multiselect(
        "Select records to delete",
        options=ids_to_display.keys(),
        format_func=lambda x: f"ID: {x} - Field 1: {next(record['field_1'] for record in records if str(record['_id']) == x)}"
    )
    
    if st.button("Delete Selected Records"):
        if selected_ids:
            ids_to_delete = [ObjectId(id) for id in selected_ids]  # Convert strings back to ObjectId
            result = collection.delete_many({'_id': {'$in': ids_to_delete}})
            st.success(f"Deleted {result.deleted_count} record(s).")
        else:
            st.warning("No records selected for deletion.")
else:
    st.info("No records available to delete.")

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

  tags = {
    Name = "Streamlit-App-Instance"
  }

}

# Outputs
output "mongo_instance_ip" {
  value = aws_instance.mongo_instance.private_ip
}
output "streamlit_instance_ip" {
  value = aws_instance.streamlit_app_instance.private_ip
}

output "aws_subnet_cidr_block" {
  value = data.aws_subnet.default_subnet.cidr_block
}

output "visit_app" {
  value = "visit url: http://${aws_instance.streamlit_app_instance.public_ip}:8501 to access app. Wait for, ec2 instances install dependencies."
}