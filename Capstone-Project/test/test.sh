#!/bin/bash

# Fetch the URL from Terraform output
URL=$(terraform output -raw alb_url)

# Number of requests
NUM_REQUESTS=50

# Loop to send requests
for ((i=1; i<=NUM_REQUESTS; i++)); do
    RESPONSE=$(curl -s -o /dev/null -w "%{http_code} %{remote_ip}\n" $URL)
    echo "Request $i: $RESPONSE"
    sleep 0.01 # Optional: To avoid overwhelming the server
done
