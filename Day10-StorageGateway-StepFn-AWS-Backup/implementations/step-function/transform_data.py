import json

def handler(event, context):
    # Transform the data (for this example, just converting to uppercase)
    transformed_data = event['body'].upper()
    print(f"Transformed data: {transformed_data}")
    
    return {
        'statusCode': 200,
        'body': json.dumps(transformed_data)
    }
