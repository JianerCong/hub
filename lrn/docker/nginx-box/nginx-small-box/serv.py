import web
import json
import sys

urls = (
    '/', 'hi',
)

class hi:
    def GET(self):
        return f'response from {sys.argv[1]}'


if __name__ == '__main__':
    app = web.application(urls, globals())
    app.run()
