import web
import json
import logging

logger = logging.getLogger()
print = logger.info

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
        d = json.loads(data)
        print(f'Data recieved: {d}')
        return json.dumps({'msg':'Okay','data': d})

class query:
    def GET(self):
        get_input = web.input(_method='get')
        print(f'get_input: {get_input}')
        print(f"is a in the query param?: {'a' in get_input}")
        print(f'a is : {get_input.get("a", "NOT FOUND")}')
        return 'ok'


def handler(event, start_response):
    return web.application(urls, globals()).wsgifunc()(event,start_response)
