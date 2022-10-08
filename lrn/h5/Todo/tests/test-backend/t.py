import requests

url = 'http://localhost:8001/todos'
myobj = {'name': 'aaa'}

x = requests.post(url, json = {'name':'aaa'})
x2 = requests.post(url, json = {'name':'bbb'})

print(x.text)


print('Getting ')
y = requests.get(url)
print(y.status_code)
