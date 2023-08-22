

from subprocess import Popen, PIPE
import pathlib
from pathlib import Path
import re

import time
def test_serv_open_close():
    time.sleep(2)                   #  2sec
    # this wait for PIPEs  and port binding/unbinding
    p = Popen(['./myexe'],stdin=PIPE,stdout=PIPE,stderr=PIPE,text=True)
    o,e = p.communicate('\n')         # send a \n and wait for completion
    print(f'OUT--------------------------------------------------')
    print(o)
    print(f'ERR--------------------------------------------------')
    print(e)
    assert p.returncode == 0


import requests #pip install requests
import json
url = 'http://localhost:7777/'


def test_serv_basic_request():
    time.sleep(2)                   #  1sec
    p = Popen(['./myexe'],stdin=PIPE,stdout=PIPE,stderr=PIPE,text=True)
    result = requests.get(url + 'aaa')
    assert result.ok
    assert result.content == b'result for /aaa'


    # stop server--------------------------------------------------
    o,e = p.communicate('\n')         # send a \n and wait for completion
    print(f'OUT--------------------------------------------------')
    print(o)
    print(f'ERR--------------------------------------------------')
    print(e)

    assert p.returncode == 0
