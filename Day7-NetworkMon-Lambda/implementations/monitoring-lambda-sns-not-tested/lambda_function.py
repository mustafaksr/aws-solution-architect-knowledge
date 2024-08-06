import json, os
import boto3

# Initialize the clients for EC2 and SNS
ec2_client = boto3.client('ec2')
sns_client = boto3.client('sns')

# Replace with your SNS topic ARN
SNS_TOPIC_ARN = os.environ["SNS_TOPIC_ARN"]

def lambda_handler(event, context):
    """
    Lambda handler function to process EC2 instance state-change events,
    stop instances when conditions are met, and send notifications.
    """
    
    # Log the incoming event for debugging purposes
    print("Received event: " + json.dumps(event, indent=2))

    # Extract relevant details from the event
    instance_id = event['detail']['instance-id']
    state = event['detail']['state']

    # Example: Stop the instance if it's running (you can add more conditions)
    if state == 'running':
        try:
            # Describe the instance
            response = ec2_client.describe_instances(InstanceIds=[instance_id])
            instance_info = response['Reservations'][0]['Instances'][0]

            # Optional: Add custom logic to decide whether to stop the instance
            # For example, based on tags, instance type, etc.

            # Stop the instance
            ec2_client.stop_instances(InstanceIds=[instance_id])
            print(f"Stopped instance: {instance_id}")

            # Send notification
            message = f"Instance {instance_id} was stopped due to an abuse report."
            sns_client.publish(
                TopicArn=SNS_TOPIC_ARN,
                Message=message,
                Subject="EC2 Instance Stopped"
            )
            print("Notification sent to SNS topic")

        except Exception as e:
            print(f"Error stopping instance {instance_id}: {str(e)}")
            raise

    return {
        'statusCode': 200,
        'body': json.dumps('Handler completed successfully')
    }
