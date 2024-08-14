import json
import mysql.connector
import os

def lambda_handler(event, context):
    # Get environment variables
    db_host = os.environ['db_host']
    db_user = 'admin'  # Replace with your DB username
    db_password = os.environ['db_password']
    db_name = 'employees'  # Replace with your DB name

    # Establish a connection to the MySQL database
    try:
        conn = mysql.connector.connect(
            host=db_host,
            user=db_user,
            password=db_password,
            database=db_name
        )
        cursor = conn.cursor()
    except mysql.connector.Error as err:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(err)})
        }

    # Extract data from the event
    body = json.loads(event['body'])
    name = body.get('name')
    age = body.get('age')
    email = body.get('email')

    # Insert the data into the database
    try:
        sql_insert = "INSERT INTO employees (name, age, email) VALUES (%s, %s, %s)"
        cursor.execute(sql_insert, (name, age, email))
        conn.commit()
        cursor.close()
        conn.close()

        return {
            'statusCode': 200,
            'body': json.dumps({'message': 'Data inserted successfully!'})
        }
    except mysql.connector.Error as err:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(err)})
        }
