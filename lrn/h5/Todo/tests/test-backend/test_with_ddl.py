import requests #pip install requests
import json
import re
url = 'http://localhost:9001/todos'


def test_postmany_with_ddl():
    requests.delete(url)        # clear the db
    a={'unam':'aaa', 'todos':[{'name':'a1'},
                              {'name':'a2', 'done':True},
                              {'name':'a3', 'done':True, 'ddl': '2000-01-01'},
                              ]}
    result = requests.post(url + '/postmany/',json=a)

    # get all and check the values
    result = requests.get(url)
    todos = json.loads(result.content)

    x, x2, x3 = todos[0], todos[1], todos[2]
    assert x['name'] == 'a1'
    assert x['done'] == False

    assert x2['name'] == 'a2'
    assert x2['done'] == True

    assert x3['name'] == 'a3'
    assert x3['done'] == True
    assert x3['ddl'] == '2000-01-01'


def test_post():
    requests.delete(url)        # clear the db
    # Add two items
    x = requests.post(url, json = {'name':'aaa', 'ddl': '2000-01-01'})
    x = requests.post(url, json = {'name':'aaa', 'ddl': '2000-01-02'})

    # get all and check the values
    result = requests.get(url)
    todos = json.loads(result.content)

    x, x2 = todos[0], todos[1]
    assert x['name'] == 'aaa'
    assert x['done'] == False
    assert x['ddl'] == '2000-01-01'

    assert x2['name'] == 'aaa'
    assert x2['done'] == False
    assert x2['ddl'] == '2000-01-02'
