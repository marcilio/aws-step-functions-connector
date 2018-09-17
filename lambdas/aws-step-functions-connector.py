# ------------------------------------------------------------------------------
# This Lambda function inspects the s3_file files within an S3 bucket/path and 
# groups them into evenly-sized payloads that can be copied in parallel by 
# multiple Lambda functions. The grouping allows Lambda functions to work on a
# reasonably-sized payload that can be processed within Lambda's max execution time
# of 5 min.
# ------------------------------------------------------------------------------

from jinja2 import Environment, BaseLoader
import boto3
import logging
import os
import json

s3 = boto3.client('s3')
logger = logging.getLogger()
logger.setLevel(logging.INFO)

s3_bucket = os.environ['TemplatesS3Bucket']
s3_template_name = os.environ['TemplateName']

def get_s3_object_content(s3_bucket, s3_file):
    response = s3.get_object(Bucket=s3_bucket, Key=s3_file)
    return response['Body'].read().decode('utf-8')

def handler(event, context):
    try:
        logger.info('Input: {}'.format(event))
        template_content = get_s3_object_content(s3_bucket, s3_template_name)
        template = Environment(loader=BaseLoader()).from_string(template_content)
        output = template.render(event)
        logger.info('Output: {}'.format(output))
        return json.loads(output)
    except Exception as e:
        logger.error(str(e))
        raise
