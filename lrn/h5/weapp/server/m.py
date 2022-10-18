import web
import json

from pymongo import MongoClient
from pymongo.errors import ConnectionFailure

urls = (
    '/', 'hi',
    '/test', 'm1',
    '/json', 'serveJSON',
    '/q', 'query',
)



class hi:
    def GET(self):
        return 'aaa'

class m1:
    print('initializing m1:')
    ok = False
    if not ok:
        print('initializing client')
        client = MongoClient('mongodb://localhost:27017/')
        try:
            # The ping command is cheap and does not require auth.
            print('\nconnecting to db: ',end='')
            client.admin.command('ping')
            print("❄ Okay ")
        except ConnectionFailure:
            print("😭 Server not available")
            exit()
        ok = True

    # Method 1: open-close conn evry time--------------------------------------------------
    # def __init__(self):
    #     client = MongoClient('mongodb://localhost:27017/')
    #     try:
    #         # The ping command is cheap and does not require auth.
    #         print('\nconnecting to db: ',end='')
    #         client.admin.command('ping')
    #         print("❄ Okay ")
    #     except ConnectionFailure:
    #         print("😭 Server not available")

    #     self.client = client
    #     self.df = client.myDb.myTable

    # def __del__(self):
    #     print('closing db')
    #     self.client.close()

    # Method 2: use a global client --------------------------------------------------
    def __init__(self):
        self.df = m1.client.myDb.myTable

    def GET(self):
        query_dict = web.input(_method='get')
        if 'code' not in query_dict:
            return json.dumps({'ok': False, 'msg': 'code not given in query param'})

        # res = []
        # openid = 0

        code = query_dict['code']
        openid = self.code2id(code)

        # get the data from client
        res = self.df.find_one({'openid':openid})
        if res == None:
            res = []

        return json.dumps({'ok': True, 'openid': openid, 'todos': res})




    def code2id(self, code):
        print(f'converting code {code} to openid')
        # calls Wechat API here...
        # ...
        openid = code

        return openid

class serveJSON:
    def GET(self):
        d = {'one':1,'two':2}
        web.header('Content-Type', 'application/json')
        return json.dumps(d)

    def POST(self):
        data = web.data()
        web.header('Content-Type', 'application/json')
        print(f'Data recieved: {json.loads(data)}')
        return json.dumps({'msg':'Okay'})

class query:
    def GET(self):
        query_dict = web.input(_method='get')
        print(f'query_dict: {query_dict}')
        print(f"is a in the query param?: {'a' in query_dict}")
        print(f'a is : {query_dict.get("a", "NOT FOUND")}')
        return 'ok'


if __name__ == '__main__':

    app = web.application(urls, globals())
    app.run()
    # web.py is smart enough to run the code below
    print('closing connection')
    m1.client.close()
