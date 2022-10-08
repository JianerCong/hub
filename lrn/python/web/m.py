import web
import json

urls = (
    '/', 'hi',
    '/json', 'serveJSON',
    '/q', 'query',
)

class hi:
    def GET(self):
        return 'aaa'

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
        get_input = web.input(_method='get')
        print(f'get_input: {get_input}')
        print(f"is a in the query param?: {'a' in get_input}")
        print(f'a is : {get_input.get("a", "NOT FOUND")}')
        return 'ok'


if __name__ == '__main__':
    app = web.application(urls, globals())
    app.run()
