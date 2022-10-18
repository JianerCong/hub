import pytest

from pymongo import MongoClient
from pymongo.errors import ConnectionFailure

"""

In this table (myDb.myTable), the `name` attribute is set to an unique index.

"""
@pytest.fixture()
def df():
    client = MongoClient('mongodb://localhost:27017/')
    try:
    # The ping command is cheap and does not require auth.
        print('\nconnecting to db: ',end='')
        client.admin.command('ping')
        print("❄ Okay ")
    except ConnectionFailure:
        print("😭 Server not available")

    df = client.myDb.myTable
    df.delete_many({})
    yield df
    client.close()
    print("🐸 connection closed")

def test_one():
    assert 1 == 1

def test_clear_document(df):
    current_count = df.count_documents({})
    res = df.delete_many({})
    assert current_count == res.deleted_count

def test_insert_one(df):
    # the `name` is already set as key(index).
    item = {'name': 'aaa', 'value': 123}
    df.replace_one(filter={'name': 'aaa'}, replacement=item,upsert=True)

    assert df.count_documents({}) == 1

from datetime import datetime

def test_insert_one_with_datetime(df):
    # the `name` is already set as key(index).
    item = {'name': 'aaa', 'value': 123, 'date' : datetime.utcnow()}
    df.replace_one(filter={'name': 'aaa'}, replacement=item,upsert=True)

    assert df.count_documents({}) == 1

def test_find_one(df):
    # insert the item
    item = {'name': 'aaa', 'value': 123, 'date' : datetime.fromisoformat('2011-01-01')}
    df.replace_one(filter={'name': 'aaa'}, replacement=item,upsert=True)

    # get the item
    res = df.find_one({'name':'aaa'})
    assert res['name'] == 'aaa'
    assert res['value'] == 123
    assert res['date'].isoformat()[0:10] == '2011-01-01'

def test_find_nonexisting_one(df):
    # insert the item
    item = {'name': 'aaa', 'value': 123, 'date' : datetime.fromisoformat('2011-01-01')}
    df.replace_one(filter={'name': 'aaa'}, replacement=item,upsert=True)

    # get the item
    res = df.find_one({'name':'bbb'})
    assert res == None
