import json
import boto3

def lambda_handler(event, context):
    try:
        client = boto3.client('ec2')
        custom_filter = [
            {
                'Name':'tag:Name', 
                'Values': ['HelloWorld']
            },
            {
                'Name':'tag:Project', 
                'Values': ['Serverless']
            },    
        ]
        response = client.describe_instances(Filters=custom_filter)
        instance_ids = []
        for reservation in response['Reservations']:
            for instance in reservation['Instances']:
                instance_ids.append(instance['InstanceId'])
        print("Apagando las siguientes instancias" + str(instance_ids))
        client.stop_instances(InstanceIds=instance_ids)
        return {
            'statusCode': 200,
            'body': json.dumps(response, default=str)
        }
    except Exception as e:
        print(str(e))
        return {
            'statusCode': 400,
            'body': 'Error'
        }
        