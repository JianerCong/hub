import pytest
import requests #pip install requests
import json
import re
url = 'http://localhost:9002/'


@pytest.fixture()
def f():
    # clear the db before and afterwards
    requests.get(url + 'clear/')
    yield None
    requests.get(url + 'clear/')

def test_delete_no_users(f):
    r = requests.get(url + 'clear/')
    # print(f'content: {r.content}')
    r = json.loads(r.content)
    assert 0 == r['deleted']

def test_delete_one_user(f):
    r = requests.post(url + 'signup/',json={'unam':'a1','pswd':'123'})
    r = requests.get(url + 'clear/')
    # print(f'content: {r.content}')
    r = json.loads(r.content)
    assert r['deleted'] == 1

def test_signup_one_user(f):
    r = requests.post(url + 'signup/',json={'unam':'a1','pswd':'123'})
    r = json.loads(r.content)
    assert r['ok']

def test_signup_two_duplicate(f):
    requests.post(url + 'signup/',json={'unam':'a1','pswd':'123'})
    r = requests.post(url + 'signup/',json={'unam':'a1','pswd':'123'})

    r = json.loads(r.content)

    assert not r['ok']
    assert r['msg'] ==  'User name already exists'

def test_signup_two_different(f):
    requests.post(url + 'signup/',json={'unam':'a1','pswd':'123'})
    r = requests.post(url + 'signup/',json={'unam':'a2','pswd':'123'})

    r = json.loads(r.content)

    assert r['ok']

def test_login_in(f):
    requests.post(url + 'signup/',json={'unam':'a1','pswd':'123'})
    r = requests.post(url + 'login/',json={'unam':'a1','pswd':'123'})
    r = json.loads(r.content)

    assert r['ok']


def test_login_not_in(f):
    requests.post(url + 'signup/',json={'unam':'a1','pswd':'123'})
    r = requests.post(url + 'login/',json={'unam':'a1','pswd':'1234'})
    r = json.loads(r.content)

    assert not r['ok']
    assert r['msg'] == 'Wrong password'


def test_login_not_in_pswd(f):
    requests.post(url + 'signup/',json={'unam':'a1','pswd':'123'})
    r = requests.post(url + 'login/',json={'unam':'a0','pswd':'123'})
    r = json.loads(r.content)

    assert not r['ok']
    assert r['msg'] == 'No such user'
