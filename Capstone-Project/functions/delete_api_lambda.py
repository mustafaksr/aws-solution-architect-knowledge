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
    employee_id = body.get('id')

    # Check if the record exists before deleting
    try:
        # Check if the record exists
        cursor.execute("SELECT COUNT(*) FROM employees WHERE id = %s", (employee_id,))
        record_exists = cursor.fetchone()[0] > 0
        
        if not record_exists:
            return {
                'statusCode': 404,
                'body': json.dumps({'message': 'Record not found'})
            }

        # Delete the record
        sql_delete = "DELETE FROM employees WHERE id = %s"
        cursor.execute(sql_delete, (employee_id,))
        conn.commit()

        # Close connections
        cursor.close()
        conn.close()

        return {
            'statusCode': 200,
            'body': json.dumps({'message': 'Data deleted successfully!'})
        }
    except mysql.connector.Error as err:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(err)})
        }
