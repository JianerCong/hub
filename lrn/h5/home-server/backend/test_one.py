import requests #pip install requests
import json
import re
from pathlib import Path

url = 'http://localhost:7777/'


def test_hi():
    assert requests.get(url + 'hi/aaa').text == 'hi aaa'

def test_clear_and_get():
    o = requests.delete(url + 'rm/')
    assert o.ok
    assert o.text == 'root cleared'

    o = requests.get(url + 'get/')
    assert o.ok
    assert o.text == '[]'

def test_delete_root():
    o = requests.get(url + 'rm/')
    assert o.text == 'Cannot delete root, use DELETE /rm/ to delete do so'
    assert o.status_code == 403

def test_get_nonexistent():
    o = requests.get(url + 'get/aaa.txt')
    assert o.status_code == 404


import pytest
@pytest.fixture()
def B():
    # get the base folder name
    B = Path(requests.get(url + 'upload/').text)
    print(f'Base folder is {B}')
    assert requests.delete(url + 'rm/').ok
    yield B

def test_upload_and_get(B):
    o = requests.post(url + 'upload/aaa.txt', data=b'aaa')
    assert o.ok
    assert o.text == 'upload aaa.txt'

    o = requests.get(url + 'get/aaa.txt')
    assert o.ok
    assert o.content == b'aaa'

def test_mkdir_and_list(B):
    assert requests.get(url + 'mkdir/aaa').ok

    o = requests.get(url + 'get/')
    assert o.ok
    assert json.loads(o.content) == [{'name': str(B / 'aaa'), 'is_folder': True}]

def test_upload_and_list(B):
    assert requests.post(url + 'upload/aaa.txt', data=b'aaa').ok

    o = requests.get(url + 'get/')
    assert o.ok
    assert json.loads(o.content) == [{'name': str(B / 'aaa.txt'), 'is_folder': False}]

