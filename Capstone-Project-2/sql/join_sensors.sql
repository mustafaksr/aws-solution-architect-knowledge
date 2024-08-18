WITH t0 AS (
    SELECT temperature AS sensor_0_temperature, 
           pressure AS sensor_0_pressure, 
           humidity AS sensor_0_humidity,
           event_time
    FROM public.sensor_data
    WHERE sensor_id = 'sensor_0'
),
t1 AS (
    SELECT temperature AS sensor_1_temperature, 
           pressure AS sensor_1_pressure, 
           humidity AS sensor_1_humidity,
           event_time
    FROM public.sensor_data
    WHERE sensor_id = 'sensor_1'
),
t2 AS (
    SELECT temperature AS sensor_2_temperature, 
           pressure AS sensor_2_pressure, 
           humidity AS sensor_2_humidity,
           event_time
    FROM public.sensor_data
    WHERE sensor_id = 'sensor_2'
)
-- Add more sensors as needed
SELECT 
    t0.event_time,
    t0.sensor_0_temperature, t0.sensor_0_pressure, t0.sensor_0_humidity,
    t1.sensor_1_temperature, t1.sensor_1_pressure, t1.sensor_1_humidity,
    t2.sensor_2_temperature, t2.sensor_2_pressure, t2.sensor_2_humidity
    -- Add more columns for additional sensors
FROM t0
JOIN t1 ON t0.event_time = t1.event_time
JOIN t2 ON t0.event_time = t2.event_time
-- Add more joins for additional sensors
ORDER BY t0.event_time;
