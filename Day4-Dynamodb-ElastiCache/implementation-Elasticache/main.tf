provider "aws" {
  region = "us-east-2"  # Change this to your preferred region
}

# Create a Security Group for the EC2 instance
resource "aws_security_group" "ec2_sg" {
  name_prefix = "ec2_sg_"
  vpc_id      = data.aws_vpc.default.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8501  # Streamlit default port
    to_port     = 8501
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    from_port   = 6379  # Redis default port
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "streamlit_instance" {


  ami                    = "ami-003932de22c285676"
  instance_type          = "t2.micro"
  subnet_id              = data.aws_subnet.default_subnet.id

  iam_instance_profile   = aws_iam_instance_profile.instance_role_profile.name
  key_name               = aws_key_pair.my_key_pair.key_name
  depends_on = [aws_docdb_cluster_instance.docdb_instance] 


  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  tags = {
    Name = "StreamlitApp"
  }

  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install -y python3-pip
              pip3 install streamlit redis

              # Create the app.py file
              cat << 'EOL' > /home/ubuntu/app.py
              import streamlit as st
              import redis

              # Replace with your ElastiCache endpoint
              REDIS_HOST = "my-cache-cluster.xxxxxx.0001.use1.cache.amazonaws.com"
              REDIS_PORT = 6379

              # Create a Redis connection
              cache = redis.StrictRedis(host=REDIS_HOST, port=REDIS_PORT, decode_responses=True)

              def get_cached_data(key):
                  """Get data from Redis cache."""
                  return cache.get(key)

              def set_cache_data(key, value):
                  """Set data in Redis cache."""
                  cache.set(key, value)

              st.title('My Streamlit App')

              # Example usage
              key = 'some_key'
              cached_data = get_cached_data(key)

              if cached_data:
                  st.write(f'Cached Data: {cached_data}')
              else:
                  new_data = 'Hello, world!'
                  set_cache_data(key, new_data)
                  st.write(f'Set New Data: {new_data}')
              EOL

              # Create a script to run Streamlit
              echo "streamlit run /home/ubuntu/app.py" > /home/ubuntu/start_streamlit.sh
              chmod +x /home/ubuntu/start_streamlit.sh

              # Run Streamlit
              /home/ubuntu/start_streamlit.sh
              EOF
}


# Create an ElastiCache Redis cluster
resource "aws_elasticache_cluster" "cache" {
  cluster_id           = "my-cache-cluster"
  engine               = "redis"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1
  port                 = 6379
  parameter_group_name = "default.redis6.x"
  security_group_ids   = [aws_security_group.ec2_sg.id]
}


# Reference the default VPC
data "aws_vpc" "default" {
  default = true
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



# Create an internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = data.aws_vpc.default.id
}

# Create a route table
resource "aws_route_table" "main" {
  vpc_id = data.aws_vpc.default.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

# Associate route table with subnet
resource "aws_route_table_association" "a" {
  subnet_id      = data.aws_subnet.default_subnet.id
  route_table_id = aws_route_table.main.id
}
