import pytest

from pymongo import MongoClient
from pymongo.errors import ConnectionFailure

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

