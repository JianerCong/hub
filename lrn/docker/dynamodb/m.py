import boto3
from time import sleep

tableName = 'myLocalTable'
ddb = boto3.resource('dynamodb', endpoint_url='http://localhost:8000')
tb = ddb.Table(tableName)


# Create the DynamoDB table.
tb = ddb.create_table(
    TableName=tableName,
    KeySchema=[
        {
            'AttributeName': 'uid',
            'KeyType': 'HASH'
        },
    ],
    AttributeDefinitions=[
        {
            'AttributeName': 'uid',
            'AttributeType': 'S'
        },
    ],
    ProvisionedThroughput={
        'ReadCapacityUnits': 5,
        'WriteCapacityUnits': 5
    }
)

# # Wait until the table exists.
tb.wait_until_exists()

# Print out some data about the table.
print(f'Table {tb.table_name} of length {tb.item_count}, created at {tb.creation_date_time}')

# put item
tb.put_item(Item={'uid' : 'user1',
                  'todos' : [
                      {'name' : 'a1', 'done' : True, 'ddl': '2000-01-21'},
                      {'name' : 'a2', 'done' : False, 'ddl': ''},
]})
print(f'Now Table [{tb.table_name}] has {tb.item_count} item')
# get Item
response = tb.get_item(Key={'uid' : 'noSuchUser'})
# item = response['Item']
print(f"🐸  Got response: {response}")

tb.delete()
# ERROR ⇒ print(f'After deletion, the status is {tb.table_status}')
print(f'table removed')
