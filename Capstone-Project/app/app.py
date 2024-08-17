import streamlit as st
import requests
import os
import pandas as pd
import boto3
from io import StringIO
import json
from botocore.exceptions import ClientError

def get_ssm_parameter(parameter_name, region='us-east-2', with_decryption=False):
    # Initialize a session using Amazon SSM
    ssm_client = boto3.client('ssm', region_name=region)
    
    try:
        # Fetch the parameter
        response = ssm_client.get_parameter(
            Name=parameter_name,
            WithDecryption=with_decryption
        )
        # Extract the parameter value from the response
        parameter_value = response['Parameter']['Value']
        return parameter_value
    except ClientError as e:
        print(f"Error fetching parameter '{parameter_name}': {e}")
        return None

# Fetch parameters from AWS Systems Manager Parameter Store
api_base_url = get_ssm_parameter('/myapp/invoke_url')

# Function to make GET request to API Gateway
def fetch_data(query):
    response = requests.get(f"{api_base_url}/get", params={"query": query})
    if response.status_code == 200:
        return pd.DataFrame(json.loads(response.json()["body"]))
    else:
        st.error(f"Error: {response.status_code}, {response.text}")
        return pd.DataFrame()

# Function to make POST request to API Gateway
def insert_data(name, age, email):
    payload = {
        "body": json.dumps({
            "name": name,
            "age": age,
            "email": email
        })
    }
    response = requests.post(f"{api_base_url}/post", json=payload)
    if response.status_code == 200:
        st.success("Data inserted successfully!")
    else:
        st.error(f"Error: {response.status_code}, {response.text}")

# Function to make DELETE request to API Gateway
def delete_data(employee_id):
    response = requests.delete(f"{api_base_url}/delete", json={"body": json.dumps({"id": employee_id})})
    if response.status_code == 200:
        st.success("Data deleted successfully!")
    else:
        st.error(f"Error: {response.status_code}, {response.text}")

# Function to save DataFrame to S3 as CSV
def save_to_s3(df, filename, bucket_name):
    csv_buffer = StringIO()
    df.to_csv(csv_buffer, index=False)
    s3_resource = boto3.resource('s3')
    s3_resource.Object(bucket_name, filename).put(Body=csv_buffer.getvalue())
    st.success(f"File '{filename}' saved to S3 bucket '{bucket_name}'")

# Streamlit app
st.title("MySQL Data Viewer and Inserter via API Gateway")

# Query section
query = "SELECT * FROM employees"  # You can uncomment the following line to let users input custom queries
# query = st.text_area("Enter SQL Query:", "SELECT * FROM employees")
st.divider()
if st.button("Run Query"):
    data = fetch_data(query)
    if not data.empty:
        st.dataframe(data)


st.divider()
# Insert data section
st.header("Insert New Data")
name = st.text_input("Name")
age = st.number_input("Age", min_value=0)
email = st.text_input("Email")

if st.button("Insert Data"):
    insert_data(name, age, email)

st.divider()
# Delete data section
st.header("Delete Data")
employee_id = st.number_input("Employee ID to delete", min_value=1)

if st.button("Delete Data"):
    delete_data(employee_id)

st.divider()
if st.button("Save to S3"):
    data = fetch_data(query)
    s3_bucket_name = get_ssm_parameter('/myapp/output_bucket')
    save_to_s3(data, "query_results.csv", s3_bucket_name)