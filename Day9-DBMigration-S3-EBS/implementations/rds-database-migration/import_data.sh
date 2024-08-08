#!/bin/bash

# Update and install dependencies
# sudo apt-get update # awscli mariadb-client if not installed your system, uncomment
# sudo apt-get install -y awscli mariadb-client # if not installed your system, uncomment

# Fetch parameters from AWS Systems Manager Parameter Store
export DATABASE_HOST=$(aws ssm get-parameter --name "/myapp/db_host" --query "Parameter.Value" --region us-east-2 --output text)
export DATABASE_PASSWORD=$(aws ssm get-parameter --name "/myapp/db_password" --with-decryption --query "Parameter.Value" --region us-east-2 --output text)
export DATABASE_USER=admin

# Import the data into the RDS instance
mysql -h $DATABASE_HOST -u $DATABASE_USER -p$DATABASE_PASSWORD < ./tableau.sql
