import boto3
import logging
import traceback

# For a Boto3 client.
ddb = boto3.client('dynamodb', endpoint_url='http://localhost:8000')

# list tables
# response = ddb.list_tables()

TableName = 'myLocalTable'
AttributeDefinitions = [{'AttributeName': 'uid', 'AttributeType': 'S'}]

def clear_table(ddb,TableName):
    # clear the table --------------------------------------------------
    response = ddb.delete_table(TableName=TableName)
    print(f'🐸Deleted table: {response["TableDescription"]["TableName"]}' )

    # recreate the table
    td = response['TableDescription']
    response = ddb.create_table(AttributeDefinitions=td['AttributeDefinitions'],
                                TableName=td['TableName'],
                                KeySchema=td['KeySchema'] ,
        ProvisionedThroughput={
            'ReadCapacityUnits': 123,
            'WriteCapacityUnits': 123
        },
                                )
    print(f'🐸Recreated table: {response["TableDescription"]["TableName"]}' )


# put an item
i = {'uid': {'S': 'user1'}, 'text': {'S' : 'aaa'}}
response = ddb.put_item(TableName=TableName, Item=i)

# get an item
response = ddb.get_item(TableName=TableName, Key={'uid':{'S':'user1'}})
# response = ddb.get_item(TableName=TableName, Key={'uid':{'S':'noSuchUser'}})
if 'Item' in response:
    print(f"🐸 The found user {response.get('Item','NOT-FOUND')}")
else:
    print(f'🐸 No such user.')

# scan the table
# response = ddb.scan(TableName=TableName)


# clear the table
# try:
# except Exception as e:
#     logging.error(traceback.format_exc())
#     # Logs the error appropriately.

# response = ddb.scan(TableName=TableName)
# print(response)

# uids = [item['uid']['S'] for item in response['Items']]
# print(f'uids : {uids}')

# for each uid, remove the uid (maybe easier to delete the table and create a new one)

# -------------------------------------------------- Put a more comlex item
# print('Put a more complex item')
# item = {'uid': {'S': 'user1'},
#         'todos': {'L': [
#             {'M': {
#                 'name' : {'S' : 'a1'},
#                 'done' : {'BOOL' : True},
#                 'ddl' : {'S' : '2000-02-11'},
#             }},

#             {'M': {
#                 'name' : {'S' : 'a2'},
#                 'done' : {'BOOL' : False},
#                 'ddl' : {'S' : '2000-01-11'},
#             }},
#         ]
#                   }
#         }

# response = ddb.put_item(TableName=TableName, Item=item)

# # get an item
# print('Get a more complex item')
# response = ddb.get_item(TableName=TableName, Key={'uid':{'S':'user1'}})
# print(f'🐸 {response}')

#Turn the normal map into dynamodb format------
todos = [
    {
        'name' : 'a1',
        'done' : True,
        'ddl' : '2000-02-11'
     },
    {
        'name' : 'a2',
        'done' : False,
        'ddl' : '2000-01-11'
     },
]

todos_d = {'L': []}
