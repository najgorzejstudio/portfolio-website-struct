import json
import boto3
import os

def handler(event, context):
    TABLE_NAME = os.environ["TABLE_NAME"]

    dynamodb = boto3.resource("dynamodb")
    table = dynamodb.Table(TABLE_NAME)

    response = table.get_item(Key={"id": "visits"})

    response = table.update_item(
        Key={"id": "visits"},
        UpdateExpression="ADD #c :inc",
        ExpressionAttributeNames={"#c": "count"},
        ExpressionAttributeValues={":inc": 1},
        ReturnValues="UPDATED_NEW"
    )

    visit_count = int(response["Attributes"]["count"])

    return{
        "statusCode": 200,
        "headers": {
        "Access-Control-Allow-Origin": "https://dalo6kqnbnwm5.cloudfront.net",
        "Access-Control-Allow-Headers": "*",
        "Access-Control-Allow-Methods": "OPTIONS,GET,POST"
        },
        "body": json.dumps({"visits": visit_count})
    }