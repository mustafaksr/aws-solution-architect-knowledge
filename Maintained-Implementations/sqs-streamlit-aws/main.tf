
terraform {
  required_version = "1.9.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.63.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.4.4"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.2"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Reference the default VPC
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_key_pair" "my_key_pair" {
  key_name   = "my-aws-key"
  public_key = file("~/.ssh/my-aws-key.pub")
}

resource "aws_security_group" "web_security_group" {
  vpc_id = data.aws_vpc.default.id

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
    from_port   = 8501
    to_port     = 8501
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

# Create an SQS queue for message handling
resource "aws_sqs_queue" "sensor_data_queue" {
  name = "sensor-data-queue"
}




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

resource "aws_iam_role_policy_attachment" "instance_role_policy_attachment" {
  role       = aws_iam_role.instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "instance_role_ssm_policy_attachment" {
  role       = aws_iam_role.instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}

resource "aws_iam_instance_profile" "instance_role_profile" {
  name = "instance-role-profile"
  role = aws_iam_role.instance_role.name
}

# Output the SQS Queue URL
output "sqs_queue_url" {
  value = aws_sqs_queue.sensor_data_queue.id
}

# Define a null_resource with local-exec provisioner
resource "null_resource" "run_python_script" {
  depends_on = [aws_sqs_queue.sensor_data_queue]

  provisioner "local-exec" {
    command = "nohup python streaming.py False &"
    
    environment = {
      SQS_QUEUE_URL =  aws_sqs_queue.sensor_data_queue.id
    }
  }
}
 
 #TODO : define ssm for SQS_QUEUE_URL = aws_sqs_queue.sensor_data_queue.id
 #TODO : define ssm for var.AWS_ACCESS_KEY_ID
  #TODO : define ssm for var.AWS_SECRET_ACCESS_KEY

# SSM Parameter for SQS_QUEUE_URL
resource "aws_ssm_parameter" "sqs_queue_url" {
  name  = "/myapp/sqs_queue_url"
  type  = "String"
  value = aws_sqs_queue.sensor_data_queue.id
}

# SSM Parameter for AWS_ACCESS_KEY_ID
resource "aws_ssm_parameter" "aws_access_key_id" {
  name  = "/myapp/aws_access_key_id"
  type  = "String"
  value = var.AWS_ACCESS_KEY_ID # Replace with actual AWS Access Key ID
}

# SSM Parameter for AWS_SECRET_ACCESS_KEY
resource "aws_ssm_parameter" "aws_secret_access_key" {
  name  = "/myapp/aws_secret_access_key"
  type  = "String"
  value = var.AWS_SECRET_ACCESS_KEY # Replace with actual AWS Secret Access Key
}


resource "aws_instance" "streamlit_app_instance" {
  ami                    = "ami-003932de22c285676"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.my_key_pair.key_name
  vpc_security_group_ids = [aws_security_group.web_security_group.id]
  iam_instance_profile   = aws_iam_instance_profile.instance_role_profile.name
  depends_on             = [aws_sqs_queue.sensor_data_queue]

  user_data = <<-EOF
#!/bin/bash -ex
sudo apt-get update
sudo apt-get install -y python3-pip python3-dev nginx awscli
pip3 install streamlit boto3 botocore

# Configure AWS CLI
aws configure set aws_access_key_id ${var.AWS_ACCESS_KEY_ID}
aws configure set aws_secret_access_key ${var.AWS_SECRET_ACCESS_KEY}
aws configure set region ${var.aws_region}

# Fetch SSM parameters
aws ssm get-parameter --name "/myapp/sqs_queue_url" --with-decryption --query "Parameter.Value" --output text > /home/ubuntu/sqs_queue_url.txt
aws ssm get-parameter --name "/myapp/aws_access_key_id" --with-decryption --query "Parameter.Value" --output text > /home/ubuntu/aws_access_key_id.txt
aws ssm get-parameter --name "/myapp/aws_secret_access_key" --with-decryption --query "Parameter.Value" --output text > /home/ubuntu/aws_secret_access_key.txt

cat <<'EOL' > /home/ubuntu/app.py
import pandas as pd
import json
import streamlit as st
import threading
import time
import os
import boto3

# SQS Client setup
def create_sqs_client():
    with open('/home/ubuntu/aws_access_key_id.txt', 'r') as file:
        aws_access_key_id = file.read().strip()
    with open('/home/ubuntu/aws_secret_access_key.txt', 'r') as file:
        aws_secret_access_key = file.read().strip()

    return boto3.client(
        'sqs',
        region_name="us-east-2",
        aws_access_key_id=aws_access_key_id,
        aws_secret_access_key=aws_secret_access_key
    )

# Function to process and transform streaming data
def process_data(messages):
    if not messages:
        return pd.DataFrame()

    df = pd.DataFrame(messages)

    required_columns = ['event_time', 'sensor_0_temperature', 'sensor_0_pressure', 'sensor_0_humidity',
                        'sensor_1_temperature', 'sensor_1_pressure', 'sensor_1_humidity',
                        'sensor_2_temperature', 'sensor_2_pressure', 'sensor_2_humidity']
    if not all(col in df.columns for col in required_columns):
        st.error("Required columns are missing in the DataFrame.")
        return pd.DataFrame()

    df['event_time'] = pd.to_datetime(df['event_time'], unit='ms')

    return df

# Background thread to consume SQS messages
def sqs_consumer_thread(queue_url, data_queue):
    sqs_client = create_sqs_client()
    while True:
        response = sqs_client.receive_message(
            QueueUrl=queue_url,
            MaxNumberOfMessages=10,
            WaitTimeSeconds=10
        )
        if 'Messages' in response:
            for message in response['Messages']:
                data_queue.append(json.loads(message['Body']))

                sqs_client.delete_message(
                    QueueUrl=queue_url,
                    ReceiptHandle=message['ReceiptHandle']
                )
        time.sleep(1)

# Streamlit app
def main():
    st.title("Real-Time Sensor Data Dashboard")

    with open('/home/ubuntu/sqs_queue_url.txt', 'r') as file:
        queue_url = file.read().strip()

    data_queue = []
    df_combined = pd.DataFrame()

    thread = threading.Thread(target=sqs_consumer_thread, args=(queue_url, data_queue))
    thread.daemon = True
    thread.start()

    st.write("Listening to SQS queue:", queue_url)

    temperature_chart = st.empty()
    pressure_chart = st.empty()
    humidity_chart = st.empty()
    df_emp = st.empty()

    refresh_interval = 5

    while True:
        new_messages = data_queue.copy()
        data_queue.clear()

        if new_messages:
            df_new = process_data(new_messages)
            if not df_new.empty:
                df_combined = pd.concat([df_combined, df_new], ignore_index=True)

        current_time = time.time()
        if (current_time % refresh_interval) < 1:
            if not df_combined.empty:
                df_combined = df_combined.sort_values('event_time')

                with temperature_chart.container():
                    st.subheader("Temperature Dashboard")
                    temperature_columns = [col for col in df_combined.columns if 'temperature' in col]
                    if 'event_time' in df_combined.columns and temperature_columns:
                        st.line_chart(df_combined.set_index('event_time')[temperature_columns])

                with pressure_chart.container():
                    st.subheader("Pressure Dashboard")
                    pressure_columns = [col for col in df_combined.columns if 'pressure' in col]
                    if 'event_time' in df_combined.columns and pressure_columns:
                        st.line_chart(df_combined.set_index('event_time')[pressure_columns])

                with humidity_chart.container():
                    st.subheader("Humidity Dashboard")
                    humidity_columns = [col for col in df_combined.columns if 'humidity' in col]
                    if 'event_time' in df_combined.columns and humidity_columns:
                        st.line_chart(df_combined.set_index('event_time')[humidity_columns])

                with df_emp.container():
                    st.subheader("Combined DataFrame")
                    st.dataframe(df_combined)

        time.sleep(1)

if __name__ == "__main__":
    main()

EOL

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

sudo ln -sf /etc/nginx/sites-available/streamlit /etc/nginx/sites-enabled/
sudo systemctl restart nginx
streamlit run /home/ubuntu/app.py --server.port 8501 &
EOF
}

