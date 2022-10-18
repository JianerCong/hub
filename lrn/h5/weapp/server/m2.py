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

def makeClient():
    # --------------------------------------------------
    print('initializing client')
    client = MongoClient('mongodb://localhost:27017/')

    try:
        # The ping command is cheap and does not require auth.
        print('\npinging db: ',end='')
        client.admin.command('ping')
        print("❄ Okay ")
    except ConnectionFailure:
        print("😭 Server not available")
        exit()

    return client

class m1:
    client = None

    def GET(self):
        query_dict = web.input(_method='get')
        if 'code' not in query_dict:
            return json.dumps({'ok': False, 'msg': 'code not given in query param'})

        # Get the openid------------------------------------
        code = query_dict['code']
        openid = self.code2id(code)

        # Get the content-----------------------------------
        if m1.client is None:
            print("lazy making client")
            client = makeClient()
            m1.client = client

        self.df = m1.client.myDb.myTable
        # get the data from client
        res = self.df.find_one({'openid':openid})
        if res == None:
            res = []

        return json.dumps({'ok': True, 'openid': openid, 'todos': res['todos']})

    def POST(self):
        # --------------------------------------------------
        data = web.data()
        if 'openid' not in data or 'todos' not in data:
            return json.dumps({'ok': False, 'msg': '`openid` or `todos` not given in the data'})

        # Post the data-------------------------------------

        openid = data['openid']
        todos = data['todos']
        item = {'openid': openid ,
                'todos': todos}

        if m1.client is None:
            print("lazy making client")
            client = makeClient()
            m1.client = client

        self.df = m1.client.myDb.myTable


        self.df.replace_one(filter={'openid': openid}, replacement=item,upsert=True)

        print(f'Data recieved: {json.loads(data)}')

        web.header('Content-Type', 'application/json')
        return json.dumps({'ok':True})


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

    # ??? Not working
    # if m1.client is not None:
    #     m1.client.close()
    #     print('cleaning up client')
    # else:
    #     print('no need to clean up')

