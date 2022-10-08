import requests #pip install requests
import json
import re
url = 'http://localhost:9001/todos'

def test_delete_all():
    assert requests.delete(url).ok

def test_get_all():
    """old get method: get all todos from all users. Good for testing"""
    requests.delete(url)        # clear the db
    result = requests.get(url)
    assert result.ok
    assert len(json.loads(result.content)) == 0

def test_get_all2():
    """new get method: this allows you to specify user"""
    requests.delete(url)        # clear the db
    result = requests.post(url + '/getall/')
    assert result.ok
    assert len(json.loads(result.content)) == 0

def test_postmany():
    requests.delete(url)        # clear the db
    a={'unam':'aaa', 'todos':[{'name':'a1'}, {'name':'a2', 'done':True}]}
    result = requests.post(url + '/postmany/',json=a)

    # get all and check the values
    result = requests.get(url)
    todos = json.loads(result.content)

    x, x2 = todos[0], todos[1]
    assert x['name'] == 'a1'
    assert x['done'] == False

    assert x2['name'] == 'a2'
    assert x2['done'] == True


def test_post():
    requests.delete(url)        # clear the db
    # Add two items
    x = requests.post(url, json = {'name':'aaa'})
    x2 = requests.post(url, json = {'name':'bbb', 'done':True})

    # get all and check the values
    result = requests.get(url)
    todos = json.loads(result.content)

    x, x2 = todos[0], todos[1]
    assert x['name'] == 'aaa'
    assert x['done'] == False

    assert x2['name'] == 'bbb'
    assert x2['done'] == True

def test_get_one_user():
    requests.delete(url)        # clear the db

    requests.post(url, json = {'name':'a1', 'unam': 'aaa'})
    requests.post(url, json = {'name':'a2', 'unam': 'aaa'})
    requests.post(url, json = {'name':'b1', 'unam': 'bbb'})
    requests.post(url, json = {'name':'b2', 'unam': 'bbb'})


    # get all and check the values
    result = requests.post(url + '/getall/', json = {'unam': 'aaa'})
    todos = json.loads(result.content)

    assert len(todos) == 2
    x, x2 = todos[0], todos[1]
    assert x['name'] == 'a1'
    assert x['done'] == False

    assert x2['name'] == 'a2'
    assert x2['done'] == False


def test_delete_one_user():
    requests.delete(url)        # clear the db

    requests.post(url, json = {'name':'a1', 'unam': 'aaa'})
    requests.post(url, json = {'name':'a2', 'unam': 'aaa'})
    requests.post(url, json = {'name':'b1', 'unam': 'bbb'})
    requests.post(url, json = {'name':'b2', 'unam': 'bbb'})

    # delete aaa's data
    requests.delete(url, json = {'unam': 'aaa'})
    # get all ⇒ there should only be bbb's data
    result = requests.get(url)
    todos = json.loads(result.content)

    assert len(todos) == 2
    x, x2 = todos[0], todos[1]
    assert x['name'] == 'b1'
    assert x['done'] == False

    assert x2['name'] == 'b2'
    assert x2['done'] == False

