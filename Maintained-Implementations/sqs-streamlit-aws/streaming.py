import json
import time
import math
import random
from dotenv import load_dotenv
import os
import boto3
import pandas as pd
import fire

# Load environment variables
load_dotenv()

def stream_fn(test, base_sleep_time=1, test_rows=300):
    # AWS SQS Setup
    sqs = boto3.client('sqs')  # Automatically uses AWS CLI configured credentials
    queue_url = os.environ['SQS_QUEUE_URL']

    # Define initial sensor data values
    temperature_base = [19.0, 20.0, 21.0]  # Base temperature in Celsius
    pressure_base = [800.0, 1013.25, 1200.0]  # Base pressure in hPa
    humidity_base = [60.0, 50.0, 40.0]  # Base humidity percentage

    # Amplitude and frequency for sinusoidal changes
    temp_amplitude = [10, 5, 15]
    pressure_amplitude = [700, 500, 1200]
    humidity_amplitude = [15, 5, 10]

    # Frequency of the sinusoidal wave
    frequency = 0.05

    # Define trends for the random uniform noise
    temp_trend = [4, 2, 1]
    pressure_trend = [200, 100, 50]
    humidity_trend = [1, 2, 3]

    datas = []
    sensors = ["sensor_0", "sensor_1", "sensor_2"]

    # Time variable to increment for each cycle
    time_step = 0

    while True:
        # Create a dictionary to store data for all sensors
        data_dict = {"event_time": int(time.time() * 1000)}

        for i, sensor in enumerate(sensors):
            # Simulate sinusoidal change in sensor readings
            temperature = temperature_base[i] + temp_amplitude[i] * math.sin(frequency * time_step)
            pressure = pressure_base[i] + pressure_amplitude[i] * math.sin(frequency * time_step)
            humidity = humidity_base[i] + humidity_amplitude[i] * math.sin(frequency * time_step)

            # Add random uniform noise to the sinusoidal values
            temperature += random.uniform(-temp_trend[i], temp_trend[i])
            pressure += random.uniform(-pressure_trend[i], pressure_trend[i])
            humidity += random.uniform(-humidity_trend[i], humidity_trend[i])

            # Add sensor data to the dictionary
            data_dict[f"{sensor}_temperature"] = round(temperature, 2)
            data_dict[f"{sensor}_pressure"] = round(pressure, 2)
            data_dict[f"{sensor}_humidity"] = round(humidity, 2)

        # Convert data to JSON string
        message_data = json.dumps(data_dict)

        if test:
            print(f"Published message: {message_data}")
            datas.append(data_dict)
        else:
            # Send message to AWS SQS queue
            response = sqs.send_message(
                QueueUrl=queue_url,
                MessageBody=message_data
            )
            print(f"Message sent with MessageId: {response['MessageId']}")

        # Increment the time step
        time_step += 1

        # Adjust sleep time based on the time step
        sleep_time = base_sleep_time + (time_step * 0.001)  # Example: Increase sleep time by 0.001s per step
        time.sleep(sleep_time)

        if test and len(datas) > test_rows:
            df = pd.DataFrame(datas)
            df.to_csv("sql/datas.csv", index=False)
            break

if __name__ == "__main__":
    fire.Fire(stream_fn)
