# Real-Time Sensor Data Dashboard

This Streamlit application is designed to monitor and visualize real-time sensor data from an AWS SQS queue. The app processes data from the queue, transforms it into a DataFrame, and displays various metrics including temperature, pressure, and humidity.

## Features

- **Real-Time Data Monitoring**: Continuously listens to an AWS SQS queue for incoming sensor data.
- **Data Visualization**: Displays line charts for temperature, pressure, and humidity sensors.
- **Combined Data View**: Shows a combined DataFrame with all received sensor data.

## Requirements

- Python 3.7+
- Streamlit
- Pandas
- Boto3 (AWS SDK for Python)

You can install the required Python packages using pip:

```bash
pip install streamlit pandas boto3
```

## Environment Variables

Make sure to set the following environment variables:

- `AWS_REGION`: AWS region where your SQS queue is hosted.
- `AWS_ACCESS_KEY_ID`: AWS access key ID.
- `AWS_SECRET_ACCESS_KEY`: AWS secret access key.
- `SQS_QUEUE_URL`: The URL of the SQS queue you want to monitor.

## Usage

1. Clone this repository:

    ```bash
    git clone <repository_url>
    ```

2. Navigate to the project directory:

    ```bash
    cd <project_directory>
    ```

3. Run the Streamlit app:

    ```bash
    streamlit run app.py
    ```

4. Open your web browser and go to the URL provided by Streamlit (usually `http://localhost:8501`).

## How It Works

1. **SQS Client Setup**: The `create_sqs_client` function initializes the SQS client using AWS credentials and region information.

2. **Data Processing**: The `process_data` function converts raw messages into a DataFrame, checks for required columns, and converts timestamps.

3. **SQS Consumer Thread**: A background thread continuously polls the SQS queue for messages, processes them, and appends the results to a data queue.

4. **Streamlit App**: The main function initializes the Streamlit app, starts the SQS consumer thread, and updates visualizations every few seconds based on the accumulated data.

## Data Visualization

- **Temperature Dashboard**: Line charts showing temperature data from various sensors.
- **Pressure Dashboard**: Line charts for pressure readings.
- **Humidity Dashboard**: Line charts for humidity levels.
- **Combined DataFrame**: Displays a table of all accumulated sensor data.

## Troubleshooting

- **Missing Data**: Ensure that the SQS queue is receiving data in the expected format.
- **AWS Credentials**: Verify that your AWS credentials and region are correctly set in the environment variables.
- **Permissions**: Ensure that your AWS IAM role has sufficient permissions to access the SQS queue.


Run app from sh files.
install kafka and kafka create topic:
```bash
cd repo-path
wget https://downloads.apache.org/kafka/3.8.0/kafka_2.13-3.8.0.tgz
tar -xzf kafka_2.13-3.8.0.tgz
cd kafka_2.13-3.8.0

# Start Zookeeper. Kafka requires Zookeeper to manage its distributed nature.
bin/zookeeper-server-start.sh config/zookeeper.properties
# in a new window Start Kafka Broker
bin/kafka-server-start.sh config/server.properties

# create topic
bin/kafka-topics.sh --create --topic your_topic_name --bootstrap-server localhost:9092 --partitions 1 --replication-factor 1

# list topics
bin/kafka-topics.sh --list --bootstrap-server localhost:9092

```



```bash


cd kafka-streamlit

# change with your topic name
sed -i 's/your_topic_name/<change thiis with your topic>/g' app_run.sh


# to start app
./app_run.sh

# to stop app
./stop_app.sh

```


```bash
#if test==True
psql -U postgres -d postgres 
# copy and paste 

\i sql/1-create-table.sql
\i sql/2-load-data.sql
\i sql/3-create-table.sql

# or 

echo "hostname:port:your_database:your_username:your_password" > ~/.pgpass # for example: localhost:5432:postgres:postgres:000000 

psql -U postgres -d postgres -f ./sql/all_sql.sql
```


kafka
```bash
wget https://downloads.apache.org/kafka/3.8.0/kafka_2.13-3.8.0.tgz
tar -xzf kafka_2.13-3.8.0.tgz
cd kafka_2.13-3.8.0

# Start Zookeeper. Kafka requires Zookeeper to manage its distributed nature.
bin/zookeeper-server-start.sh config/zookeeper.properties
# in a new window Start Kafka Broker
bin/kafka-server-start.sh config/server.properties

# create topic
bin/kafka-topics.sh --create --topic your_topic_name --bootstrap-server localhost:9092 --partitions 1 --replication-factor 1

# list topics
bin/kafka-topics.sh --list --bootstrap-server localhost:9092

# Set Environment Variables
export KAFKA_BROKER_URL=localhost:9092
export KAFKA_TOPIC=your_topic_name


# test  produce message
bin/kafka-console-producer.sh --topic your_topic_name --bootstrap-server localhost:9092
# type something

# listen from 
bin/kafka-console-consumer.sh --topic your_topic_name --from-beginning --bootstrap-server localhost:9092


# Persist the Environment Variables
echo "export KAFKA_BROKER_URL=localhost:9092" >> ~/.bashrc
echo "export KAFKA_TOPIC=your_topic_name" >> ~/.bashrc
source ~/.bashrc

# without kafka
python streaming.py True

# with kafka
python streaming.py False
# listen from 
bin/kafka-console-consumer.sh --topic your_topic_name --from-beginning --bootstrap-server localhost:9092



export POSTGRES_USER=your_postgres_user
export POSTGRES_PASSWORD=your_postgres_password
export POSTGRES_DB=your_postgres_db
export POSTGRES_HOST=your_postgres_host
export POSTGRES_PORT=your_postgres_port

export KAFKA_BROKER_URL="localhost:9092"
export KAFKA_TOPIC="your_topic_name"
export POSTGRES_USER="postgres"
export POSTGRES_PASSWORD="123456"
export POSTGRES_DB="postgres"
export POSTGRES_HOST="localhost"
export POSTGRES_PORT="5432"

python beam.py \
  --runner=DirectRunner \
  --kafka_topic $KAFKA_TOPIC \
  --kafka_bootstrap $KAFKA_BROKER_URL \
  --postgres_url "jdbc:postgresql://$POSTGRES_HOST:$POSTGRES_PORT/$POSTGRES_DB?user=$POSTGRES_USER&password=$POSTGRES_PASSWORD" \
  --batch_size 10

```


```bash
export KAFKA_BROKER_URL="localhost:9092"
export KAFKA_TOPIC="your_topic_name"
export POSTGRES_USER="postgres"
export POSTGRES_PASSWORD="123456"
export POSTGRES_DB="postgres"
export POSTGRES_HOST="localhost"
export POSTGRES_PORT="5432"
export BATCH_SIZE="10"
python beam.py


```

```
CREATE TABLE sensors_data (
    event_time VARCHAR(255) NOT NULL,
    sensor_0_temperature FLOAT,
    sensor_0_pressure FLOAT,
    sensor_0_humidity FLOAT,
    sensor_1_temperature FLOAT,
    sensor_1_pressure FLOAT,
    sensor_1_humidity FLOAT,
    sensor_2_temperature FLOAT,
    sensor_2_pressure FLOAT,
    sensor_2_humidity FLOAT
);

```


        ```bash
        #ssh for vm, log init script
        sudo tail -f /var/log/cloud-init-output.log # follow log
        sudo cat /var/log/cloud-init-output.log # all log
        ```