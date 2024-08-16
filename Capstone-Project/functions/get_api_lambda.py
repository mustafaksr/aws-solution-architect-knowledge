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
        cursor = conn.cursor(dictionary=True)
    except mysql.connector.Error as err:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(err)})
        }

    # Extract the query from the event
    sql_query = "SELECT * FROM employees"  # Replace with actual query or extract from event['query']

    try:
        cursor.execute(sql_query)
        rows = cursor.fetchall()
        cursor.close()
        conn.close()
        
        # Return the results
        return {
            'statusCode': 200,
            'body': json.dumps(rows)
        }
    except mysql.connector.Error as err:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(err)})
        }
