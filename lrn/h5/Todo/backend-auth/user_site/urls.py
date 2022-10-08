"""user_site URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/4.1/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""

import json
from django.contrib.auth.models import User
from django.contrib import admin
from django.urls import path
from django.http import JsonResponse, HttpResponse

def deleteAll(req):
    # delete all users except for the admin user
    n = User.objects.count() - 1
    while User.objects.count() > 1:
        print(f'Deleting user {User.objects.last().username}')
        User.objects.last().delete()
    return JsonResponse({'deleted': n})

from django.views.decorators.csrf import csrf_exempt
from django.http import HttpResponseServerError

MSG = {
    'unam_exists': {'en': 'User name already exists', 'zh': '用户名已被注册'},
    'no_such_user': {'en': 'No such user', 'zh': '没这个用户'},
    'wrong_pswd': {'en': 'Wrong password', 'zh': '密码错误'}
}

@csrf_exempt
def signUp(req):
    if req.method == 'POST':
        # print(f'body: {req.body}')
        data = json.loads(req.body)
        # print(f'data: {data}')
        try:
            unam = data['unam']
            pswd = data['pswd']
            lang = data.get('lang', 'en')
        except KeyError:
          HttpResponseServerError("Malformed data!")

        print(f'Signing up for ({unam},{pswd})')

        # check duplicated username
        if User.objects.filter(username=unam).count() > 0:
            return JsonResponse({'ok': False, 'msg': MSG['unam_exists'][lang]})

        try:
            User.objects.create_user(unam,'',pswd).save()
            return JsonResponse({'ok': True, 'msg':'Okay'})
        except Exception as e:
            return JsonResponse({'ok': False,
                                 'msg': f'Error creating user on server: {e}'})

@csrf_exempt
def logIn(req):
    if req.method == 'POST':
        # print(f'body: {req.body}')
        data = json.loads(req.body)
        # print(f'data: {data}')

        try:
            unam = data['unam']
            pswd = data['pswd']
            lang = data.get('lang', 'en')
        except KeyError:
          HttpResponseServerError("Malformed data")

        print(f'Logging in for ({unam},{pswd})')

        # check user exists?
        if User.objects.filter(username=unam).count() != 1:
            return JsonResponse({'ok': False, 'msg': MSG['no_such_user'][lang]})

        user = User.objects.get(username=unam)
        if user.check_password(pswd):
            return JsonResponse({'ok': True, 'msg':'Okay'})
        return JsonResponse({'ok': False, 'msg':MSG['wrong_pswd'][lang]})

urlpatterns = [
    path('hi/',lambda req: HttpResponse('hi from todo-auth'),name='hi'),
    path('clear/',deleteAll,name='deleteAllUsers'),
    path('signup/',signUp,name='signUp'),
    path('login/',logIn,name='logIn'),
    path('admin/', admin.site.urls),
]
