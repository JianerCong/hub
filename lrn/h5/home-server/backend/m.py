import web
import json
import sys
from pathlib import Path

urls = (
    '/hi/(.*)', 'Hi',
    '/rm/(.*)','Deleter',
    '/get/(.*)','Downloader',
    '/mkdir/(.*)','FolderMaker',
    '/upload/(.*)','Uploader',
)

B = Path.cwd() / '.base'
# create the base dir if it doesn't exist
if not B.exists():
    print(f'Creating {B}')
    B.mkdir(parents=True)

class Hi:
    def GET(self,name):
        return f'hi {name}'

class Deleter:
    def GET(self,name):
        return f'remove {B / name}'

class Downloader:
    def GET(self,name):
        p = B / name
        if not p.exists():
            # 404
            raise web.notfound()
        with open(p, 'rb') as f:
            web.header('Content-Disposition', f'attachment; filename="{name}"')
            return f.read()

class FolderMaker:
    def GET(self,name):
        p = B / name
        if not p.exists():
            print(f'Creating {p}')
            p.mkdir(parents=True)
        return f'mkdir {B / name}'

class Uploader:
    def POST(self,name):
        p = B / name
        if not p.parent.exists():
            print(f'Creating {p.parent}')
            p.parent.mkdir(parents=True)
        with open(p, 'wb') as f:
            f.write(web.data())
        return f'write to {B / name}'

# class serveJSON:
#     def GET(self):
#         d = {'one':1,'two':2}
#         web.header('Content-Type', 'application/json')
#         return json.dumps(d)

#     def POST(self):
#         data = web.data()
#         web.header('Content-Type', 'application/json')
#         print(f'Data recieved: {json.loads(data)}')
#         return json.dumps({'msg':'Okay'})

# class query:
#     def GET(self):
#         get_input = web.input(_method='get')
#         print(f'get_input: {get_input}')
#         print(f"is a in the query param?: {'a' in get_input}")
#         print(f'a is : {get_input.get("a", "NOT FOUND")}')
#         return 'ok'


if __name__ == '__main__':
    print(f'Starting at base dir {B}')

    print(f'Args: {sys.argv}')
    app = web.application(urls, globals())
    app.run()
