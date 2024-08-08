#!/bin/bash



# Fetch Terraform outputs
MONGO_HOST=$(terraform output -raw mongodb_uri)
MONGO_PASSWORD=$(terraform output -raw mongodb_password)
MONGO_USER=$(terraform output -raw mongodb_user)
MONGO_PORT=27017

mongorestore --host $MONGO_HOST --port $MONGO_PORT   ./db_dump

