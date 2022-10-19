import pytest
import requests
import json

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

url = 'http://localhost:8080/test'
def test_post(df):
    a={'openid':'a1', 'todos':[{'name':'a1'}, {'name':'a2', 'done':True}]}
    result = requests.post(url,json=a)

    assert df.count_documents({}) == 1

def test_get(df):
    item = {'openid': 'a2', 'todos': [{'name':'t1'}, {'name':'t2', 'done': True}]}
    df.replace_one(filter={'name': 'a2'}, replacement=item,upsert=True)

    res = requests.get(url + '?code=a2')

    res = json.loads(res.content)
    assert res['openid'] == item['openid']

def test_get_without_code():
    res = requests.get(url + '?c1=123')

    res = json.loads(res.content)
    assert res['ok'] == False
    assert res['msg'] == 'code not given in query param'
