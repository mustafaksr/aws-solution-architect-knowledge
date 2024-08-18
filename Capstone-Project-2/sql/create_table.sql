CREATE TABLE sensor_data (
    sensor_id VARCHAR(50) NOT NULL,
    temperature DECIMAL(5, 2) NOT NULL,
    pressure DECIMAL(6, 2) NOT NULL,
    humidity DECIMAL(5, 2) NOT NULL,
    event_time BIGINT NOT NULL,
    PRIMARY KEY (sensor_id, event_time)
);
