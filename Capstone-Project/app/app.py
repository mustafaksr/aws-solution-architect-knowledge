#TODO: UPDATE Streamlit app to use API GATEWAY routes instead of using mysql.connector
#test
import streamlit as st
import requests
import os
import pandas as pd
import boto3
from io import StringIO
import json


# Fetching environment variables
api_base_url = os.getenv('API_BASE_URL')  # API Gateway base URL
s3_bucket_name = os.getenv('OUTPUT_BUCKET_NAME')

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
    response = requests.post(f"{api_base_url}/post", json={"name": name, "age": age, "email": email})
    if response.status_code == 200:
        st.success("Data inserted successfully!")
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
query = "SELECT * FROM employees" #st.text_area("Enter SQL Query:", "SELECT * FROM employees")

if st.button("Run Query"):
    data = fetch_data(query)
    if not data.empty:
        st.dataframe(data)
        if st.button("Save to S3"):
            save_to_s3(data, "query_results.csv", s3_bucket_name)

# Insert data section
st.header("Insert New Data")
name = st.text_input("Name")
age = st.number_input("Age", min_value=0)
email = st.text_input("Email")

if st.button("Insert Data"):
    insert_data(name, age, email)