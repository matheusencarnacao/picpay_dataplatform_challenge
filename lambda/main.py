import requests
import boto3
import json


def lambda_handler(event, context):

    kinesis_client = boto3.client('kinesis', 'us-east-1')

    url = "https://api.punkapi.com/v2/beers/random"

    payload={}
    headers = {}

    response = requests.request("GET", url, headers=headers, data=payload)

    message = response.text

    shardCount = 1

    kinesis_response = kinesis_client.put_records(Records=[
        {
            "Data": message.encode('utf-8'),
            'PartitionKey': str(shardCount)
        },
    ], StreamName='stream')

    print(kinesis_response)

    
    return {
        'statusCode': 200,
        'body': json.dumps(kinesis_response)
    }
