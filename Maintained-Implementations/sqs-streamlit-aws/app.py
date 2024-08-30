import pandas as pd
import json
import streamlit as st
import threading
import time
import os
import boto3  # AWS SDK for Python

# SQS Client setup
def create_sqs_client():
    return boto3.client(
        'sqs',
        region_name=os.getenv("AWS_REGION"),
        aws_access_key_id=os.getenv("AWS_ACCESS_KEY_ID"),
        aws_secret_access_key=os.getenv("AWS_SECRET_ACCESS_KEY")
    )

# Function to process and transform streaming data
def process_data(messages):
    if not messages:
        return pd.DataFrame()

    # Convert list of messages to DataFrame
    df = pd.DataFrame(messages)

    # Check if required columns are present
    required_columns = ['event_time', 'sensor_0_temperature', 'sensor_0_pressure', 'sensor_0_humidity',
                        'sensor_1_temperature', 'sensor_1_pressure', 'sensor_1_humidity',
                        'sensor_2_temperature', 'sensor_2_pressure', 'sensor_2_humidity']
    if not all(col in df.columns for col in required_columns):
        st.error("Required columns are missing in the DataFrame.")
        return pd.DataFrame()  # Return an empty DataFrame if required columns are missing

    # Convert event_time to datetime
    df['event_time'] = pd.to_datetime(df['event_time'], unit='ms')

    return df

# Background thread to consume SQS messages
def sqs_consumer_thread(queue_url, data_queue):
    sqs_client = create_sqs_client()
    while True:
        response = sqs_client.receive_message(
            QueueUrl=queue_url,
            MaxNumberOfMessages=10,  # Change as needed
            WaitTimeSeconds=10  # Long polling
        )
        if 'Messages' in response:
            for message in response['Messages']:
                # Process the message
                data_queue.append(json.loads(message['Body']))

                # Delete the message after processing
                sqs_client.delete_message(
                    QueueUrl=queue_url,
                    ReceiptHandle=message['ReceiptHandle']
                )
        time.sleep(1)  # Adjust the sleep time as needed

# Streamlit app
def main():
    st.title("Real-Time Sensor Data Dashboard")

    # Replace KAFKA_TOPIC with SQS_QUEUE_URL
    queue_url = os.getenv("SQS_QUEUE_URL")

    data_queue = []
    df_combined = pd.DataFrame()

    # Start SQS consumer in a separate thread
    thread = threading.Thread(target=sqs_consumer_thread, args=(queue_url, data_queue))
    thread.daemon = True
    thread.start()

    st.write("Listening to SQS queue:", queue_url)

    # Create placeholders for charts
    temperature_chart = st.empty()
    pressure_chart = st.empty()
    humidity_chart = st.empty()
    df_emp = st.empty()

    # Periodic refresh interval
    refresh_interval = 5  # seconds

    while True:
        # Accumulate messages
        new_messages = data_queue.copy()
        data_queue.clear()

        if new_messages:
            df_new = process_data(new_messages)
            if not df_new.empty:
                df_combined = pd.concat([df_combined, df_new], ignore_index=True)

        # Update charts every refresh_interval
        current_time = time.time()
        if (current_time % refresh_interval) < 1:
            if not df_combined.empty:
                # Ensure event_time is correctly set as index
                df_combined = df_combined.sort_values('event_time')  # Sort by event_time

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

        time.sleep(1)  # To control the loop's frequency

if __name__ == "__main__":
    main()
