import pytest
import boto3


tableName = 'myLocalTable'
ddb = boto3.resource('dynamodb', endpoint_url='http://localhost:8000')
tb = ddb.Table(tableName)

def test_1():
    assert 1 == 1

@pytest.fixture()
def tb():
    print('Creating table')
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

    yield tb

    print('Deleting table')
    tb.delete()

def test_empty(tb):
    assert tb.item_count == 0

def test_put_and_get(tb):
    # put item
    item ={'uid' : 'user1',
                      'todos' : [
                          {'name' : 'a1', 'done' : True, 'ddl': '2000-01-21'},
                          {'name' : 'a2', 'done' : False, 'ddl': ''},
    ]}
    tb.put_item(Item=item)

    # get Item
    response = tb.get_item(Key={'uid' : 'user1'})
    item_got = response['Item']
    assert item == item_got
    assert tb.item_count == 1


def test_put_and_get_non_existing_item(tb):
    response = tb.get_item(Key={'uid' : 'noUser'})
    assert 'Item' not in response
