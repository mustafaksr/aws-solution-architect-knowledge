import json
import boto3
import io, os
from PIL import Image


s3_client = boto3.client('s3')

def lambda_handler(event, context):
    """
    Lambda handler function to resize images uploaded to an S3 bucket.
    The resized image is saved to another S3 bucket.
    """
    
    # Log the incoming event for debugging purposes
    print("Received event: " + json.dumps(event, indent=2))

    # Extract bucket and object key from the event
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = event['Records'][0]['s3']['object']['key']

    # Download the image from the S3 bucket
    try:
        response = s3_client.get_object(Bucket=bucket, Key=key)
        image_data = response['Body'].read()

        # Open the image with PIL
        image = Image.open(io.BytesIO(image_data))

        # Resize the image
        resized_image = image.resize((256, 256))  

        # Save the resized image to a buffer
        buffer = io.BytesIO()
        resized_image.save(buffer, format=image.format)
        buffer.seek(0)

        # Specify the output bucket and key
        output_bucket = os.environ["OUTPUT_BUCKET"]
        output_key = key.replace('input/', 'output/')

        # Upload the resized image to the output bucket
        s3_client.put_object(Bucket=output_bucket, Key=output_key, Body=buffer.getvalue())
        print(f"Resized image saved to {output_bucket}/{output_key}")

    except Exception as e:
        print(f"Error processing file {key} from bucket {bucket}: {str(e)}")
        raise

    return {
        'statusCode': 200,
        'body': json.dumps('Image resized successfully!')
    }
import json
import boto3
from PIL import Image
import io,os

s3_client = boto3.client('s3')

def lambda_handler(event, context):
    # Get the bucket and object key from the event
    bucket_name = event['Records'][0]['s3']['bucket']['name']
    object_key = event['Records'][0]['s3']['object']['key']
    
    # Download the image from S3
    response = s3_client.get_object(Bucket=bucket_name, Key=object_key)
    image_data = response['Body'].read()
    
    # Open the image with PIL
    image = Image.open(io.BytesIO(image_data))
    
    # Resize the image (example: resize to 300x300)
    resized_image = image.resize((300, 300))
    
    # Save the image to an in-memory buffer
    buffer = io.BytesIO()
    resized_image.save(buffer, format=image.format)
    buffer.seek(0)
    
    # Upload the resized image to the output S3 bucket
    output_bucket_name = 'your-output-bucket-name'
    output_object_key = f"resized-{object_key}"
    s3_client.put_object(Bucket=output_bucket_name, Key=output_object_key, Body=buffer)
    
    return {
        'statusCode': 200,
        'body': json.dumps('Image resized and uploaded successfully!')
    }
