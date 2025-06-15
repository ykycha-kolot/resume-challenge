import json
from decimal import Decimal
import boto3
from boto3.dynamodb.conditions import Key

class DecimalEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, Decimal):
            return int(obj)
        return super(DecimalEncoder, self).default(obj)

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('user_count')
COUNTER_ID = 'visits'

def lambda_handler(event, context):
    status_code = 200
    headers = {
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Headers": "Content-Type,Authorization",
        "Access-Control-Allow-Methods": "GET,POST,OPTIONS",
    }
    body = {}

    try:
        route_key = event.get('routeKey')
        if route_key == "GET /user-count":
            response = table.get_item(Key={'id': COUNTER_ID})
            count = response.get('Item', {}).get('count', 0)
            body = { 'count': count }
        elif route_key == "POST /user-count":
            response = table.update_item(
                Key={'id': COUNTER_ID},
                UpdateExpression="SET #c = if_not_exists(#c, :zero) + :inc",
                ExpressionAttributeNames={ "#c": "count" },
                ExpressionAttributeValues={ ":inc": 1, ":zero": 0 },
                ReturnValues="UPDATED_NEW"
            )
            count = response['Attributes']['count']
            body = { 'count': count }
        else:
            status_code = 400
            body = f'Unsupported route sorry: "{route_key}"'
    except Exception as e:
        status_code = 500
        body = str(e)

    return {
        'statusCode': status_code,
        'headers': headers,
        'body': json.dumps(body, cls=DecimalEncoder)
    }