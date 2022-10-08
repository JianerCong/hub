"""testProject URL Configuration

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
from django.contrib import admin
from django.urls import path
from django.http import HttpResponse, JsonResponse
from django.views.decorators.csrf import csrf_exempt
import json

@csrf_exempt
def handler(req):

    if req.method == 'GET':
        print('Handling get')
        if 'unam' in req.GET:
            unam = req.GET['unam']
            print(f'unam specified in GET as {unam}')
            return  JsonResponse({'name': 'from GET request',
                                  'unam': unam})
        else:
            print('unam not specified in GET')
        return  JsonResponse({'name': 'from GET request'})
    elif req.method == 'POST':
        return  JsonResponse({'name': 'from POST request', 'receivedBody': json.loads(req.body)})

urlpatterns = [
    path('hi/', lambda req: HttpResponse('hi from test server') ),
    path('json/', lambda req: JsonResponse({'myName': 'aaa', 'myNumber': 2}) ),
    path('test/', handler),
    path('admin/', admin.site.urls),
]
