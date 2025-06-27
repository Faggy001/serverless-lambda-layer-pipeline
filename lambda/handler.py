import boto3
import os
import logging
from utils import extract_date_parts, current_timestamp

logger = logging.getLogger()
logger.setLevel(logging.INFO)

s3_client = boto3.client('s3')
dynamodb = boto3.resource('dynamodb')
sns = boto3.client('sns')

bucket_path = os.getenv('BUCKET_PATH')
dynamodb_table_name = os.getenv('DYNAMODB_TABLE')
sns_topic_arn = os.getenv('SNS_TOPIC_ARN')

table = dynamodb.Table(dynamodb_table_name)

def handler(event, context):
    if not bucket_path:
        logger.error("BUCKET_PATH not set")
        return

    try:
        bucket_name = bucket_path.split('/')[0]
        prefix = bucket_path.split(bucket_name + '/')[1]

        response = s3_client.list_objects_v2(Bucket=bucket_name, Prefix=prefix, Delimiter='/')
        if 'Contents' not in response:
            return

        for obj in response['Contents']:
            key = obj['Key']
            if key == prefix or not key.endswith('.txt'):
                continue

            new_filename = key.split(prefix)[1]
            year, month, day = extract_date_parts(new_filename)
            if not year:
                continue

            new_key = f"{prefix}{year}/{month}/{day}/{new_filename}"
            s3_client.copy_object(Bucket=bucket_name, CopySource={'Bucket': bucket_name, 'Key': key}, Key=new_key)
            s3_client.delete_object(Bucket=bucket_name, Key=key)

            timestamp = current_timestamp()
            table.put_item(Item={'filename': new_key, 'uploaded_at': timestamp})

            sns.publish(TopicArn=sns_topic_arn, Message=f"New file uploaded: {new_key}", Subject="Upload Alert")

    except Exception as e:
        logger.error(f"Error: {str(e)}")
        raise
