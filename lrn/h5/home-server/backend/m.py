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

import shutil                   # for rmtree
class Deleter:
    def GET(self,name):
        if name == '':
            web.ctx.status = '403 Forbidden'
            return f'Cannot delete root, use DELETE /rm/ to delete do so'

        p = B / name
        # delete the file or folder
        if p.exists() and p.is_file():
            p.unlink()
        elif p.exists() and p.is_dir():
            # delete the folder and all its contents
            shutil.rmtree(p)
        else:
            # 404
            raise web.notfound()
        return f'remove {B / name}'
    def DELETE(self,name):
        # delete all the contents of the base folder
        shutil.rmtree(B)
        B.mkdir(parents=True)

        return f'root cleared'

class Downloader:
    # Download a file or get the folder listing
    def GET(self,name):
        p = B / name
        if not p.exists():
            # 404
            raise web.notfound()
        if p.is_dir():
            # return the folder listing in JSON
            web.header('Content-Type', 'application/json')
            return json.dumps([dict(name=str(x), is_folder=x.is_dir()) for x in p.iterdir()])
        with open(p, 'rb') as f:
            # return the file contents
            web.header('Content-Disposition', f'attachment; filename="{name}"')
            return f.read()

class FolderMaker:
    def GET(self,name):
        p = B / name
        if not p.parent.exists():
            web.ctx.status = '403 Forbidden'
            return f'Parent folder {p.parent} does not exist'
        if not p.exists():
            print(f'Creating {p}')
            p.mkdir()
        return f'mkdir {B / name}'

class Uploader:
    def GET(self,name):
        # return the base folder name (for debugging)
        return str(B)
    def POST(self,name):
        p = B / name
        if not p.parent.exists():
            web.ctx.status = '403 Forbidden'
            return f'Parent folder {p.parent} does not exist'
        with open(p, 'wb') as f:
            f.write(web.data())
        return f'upload {name}'

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
