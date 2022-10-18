
import json
import requests
# in the terminal, cd into src/ dir then do
# pip3 install requests -t .

## handle code 2 openid --------------------------------------------------
# def my_get_handler(qs):
#     CODE = qs.get('code',None)
#     if not CODE:
#         return json.dumps({'msg': 'code queryParam not given', 'ok': False})

#     APPID = 'wxd36a15e00824bc27'
#     SECRET ='319971ca171aa327' + 'f0bbbf9cae50c7e8'
#     url = f'https://api.weixin.qq.com/sns/jscode2session?appid={APPID}&secret={SECRET}&js_code={CODE}&grant_type=authorization_code'

#     result = requests.get(url)
#     if not result.ok:
#         return json.dumps({'msg': 'failed to get ID from API', 'ok': False})

#     result = json.loads(result.content)
#     print(f'result: {result}')
#     if 'openid' in result:
#         return(json.dumps({'openid': result['openid'] , 'ok': True}))
#     return(json.dumps({'msg': 'Failed to get openid from serverr', 'ok': False}))


## handle communicate with aws
def my_get_handler(qs):
    url = ' https://p4wu7p30di.execute-api.eu-west-2.amazonaws.com/dev/myFirstPyFunction'
    result = requests.get(url)
    if not result.ok:
        return json.dumps({'msg': 'failed to get from remote API', 'ok': False})
    result = json.loads(result.content)
    print(f'result: {result}')

    # return(json.dumps({'msgFromAWS': result}))
    return(json.dumps({'msgFromAWS': '--'}))

def main_handler(event, context):
    print('Received event: ' + json.dumps(event, indent = 2))
    # print('Received context: ' + str(context))
    if event.get('httpMethod',None) == 'GET':
        return my_get_handler(event['queryString'])
    else:
        return json.dumps({'msg': 'aaa for POST request'})

