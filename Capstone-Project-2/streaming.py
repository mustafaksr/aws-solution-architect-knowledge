import warnings
import json
import time
import math
import random
from dotenv import load_dotenv
import os
import shortuuid
import boto3
import pandas as pd

# Load environment variables
load_dotenv()

test = True

if not test:
    # AWS SNS Setup
    sns = boto3.client('sns', region_name=os.environ["AWS_REGION"])
    topic_arn = os.environ["TOPIC_ARN"]

# Define initial sensor data values
temperature_base = [15.0, 20.0, 25.0]  # Base temperature in Celsius
pressure_base = [800.0, 1013.25, 1200.0]  # Base pressure in hPa
humidity_base = [40.0, 50.0, 60.0]  # Base humidity percentage

# Amplitude and frequency for sinusoidal changes
temp_amplitude = [1.0, 2.0, 3.0]
pressure_amplitude = [1.0, 2.0, 3.0]
humidity_amplitude = [1.0, 2.0, 3.0]

# Frequency of the sinusoidal wave
frequency = 0.05

# Define trends for the random uniform noise
temp_trend = [0.2, 0.3, 0.25]
pressure_trend = [0.5, 0.6, 0.55]
humidity_trend = [0.1, 0.15, 0.12]

datas = []
sensors = ["sensor_0", "sensor_1", "sensor_2"]

# Time variable to increment for each cycle
time_step = 0

while True:
    for i, sensor in enumerate(sensors):
        # Simulate sinusoidal change in sensor readings
        temperature = temperature_base[i] + temp_amplitude[i] * math.sin(frequency * time_step)
        pressure = pressure_base[i] + pressure_amplitude[i] * math.sin(frequency * time_step)
        humidity = humidity_base[i] + humidity_amplitude[i] * math.sin(frequency * time_step)

        # Add random uniform noise to the sinusoidal values
        temperature += random.uniform(-temp_trend[i], temp_trend[i])
        pressure += random.uniform(-pressure_trend[i], pressure_trend[i])
        humidity += random.uniform(-humidity_trend[i], humidity_trend[i])

        # Create a JSON object with the sensor data
        event_time = int(time.time() * 1000)
        data = {
            "sensor_id": sensor,
            "temperature": round(temperature, 2),
            "pressure": round(pressure, 2),
            "humidity": round(humidity, 2),
            "event_time": event_time
        }

        # Convert data to JSON string and publish to SNS topic
        message_data = json.dumps(data)

        if test:
            print(f"Published message: {message_data}")
        else:
            response = sns.publish(
                TopicArn=topic_arn,
                Message=message_data
            )
            print(f"Published message {response['MessageId']}: {message_data}")

        datas.append(data)
    
    # Sleep for a short time before generating the next data point
    time.sleep(0.1)
    
    # Increment the time step
    time_step += 1
    
    if len(datas) > 3000:
        if test:
            df = pd.DataFrame(datas)
            df.to_csv("datas.csv", index=False)
        break
