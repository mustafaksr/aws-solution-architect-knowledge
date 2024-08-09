import json
import boto3


def handler(event, context):
    # Print the event to CloudWatch logs for debugging


  
    # Extract bucket name and object key from the event
    data = event
    items = data["items"]
    
    # Print extracted values to CloudWatch logs
    print(f"Bucket: {items}")


    # Your data extraction logic here
    # ...

    return {
        'statusCode': 200,
        'body': json.dumps(items)
    }
