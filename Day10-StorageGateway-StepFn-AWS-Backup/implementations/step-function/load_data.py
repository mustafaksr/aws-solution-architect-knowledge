import json
import boto3
import os

def handler(event, context):
    s3_client = boto3.client('s3')
    output_bucket = os.environ['OUTPUT_BUCKET']

    # Load transformed data from event
    transformed_data = json.loads(event['body'])
    
    # Create a file to upload
    result_file = '/tmp/transformed_data.json'
    with open(result_file, 'w') as f:
        json.dump(transformed_data, f)

    # Upload file to S3
    s3_client.upload_file(result_file, output_bucket, 'transformed_data.json')

    print(f"Uploaded transformed data to bucket {output_bucket}")

    return {
        'statusCode': 200,
        'body': json.dumps('Data loaded successfully')
    }
