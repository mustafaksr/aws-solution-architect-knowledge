#!/bin/bash

# Fetch Terraform outputs
MONGO_HOST=$(terraform output -raw mongodb_uri)
MONGO_PASSWORD=$(terraform output -raw mongodb_password)
MONGO_USER=$(terraform output -raw mongodb_user)
MONGO_PORT=27017
# Define your queries
QUERY0='db.transactions.find({}, { row_id: 1, order_id: 1, order_date: 1 }).limit(3).toArray()'
QUERY1='db.customers.find({}).limit(3).toArray()'
QUERY2='db.accounts.find({}).limit(3).toArray()'

# Execute the queries
echo ""
echo "transactions collection first 3 documents:"
mongosh --host $MONGO_HOST --port $MONGO_PORT --eval "db = db.getSiblingDB('sample_analytics'); $QUERY0"

echo ""
echo "customers collection first 3 documents:"
mongosh --host $MONGO_HOST --port $MONGO_PORT --eval "db = db.getSiblingDB('sample_analytics'); $QUERY1"

echo ""
echo "accounts collection first 3 documents:"
mongosh --host $MONGO_HOST --port $MONGO_PORT --eval "db = db.getSiblingDB('sample_analytics'); $QUERY2"
