# 🦜 : These tests can fail for some subtle reasons, run pytest repeatedly.
# There should be a chance that all tests pass. (I tried.)
"""
(myenv)  [] ~/Templates/lrn/cpp
cmake --build build-hi/
[ 66%] Built target myexe
[100%] Runing pytest 🐸
==================================================================== test session starts =====================================================================
platform linux -- Python 3.10.6, pytest-7.1.2, pluggy-1.0.0 -- /home/me/work/lcode/myenv/bin/python3
cachedir: .pytest_cache
rootdir: /home/me/Templates/lrn/cpp/build-hi
collected 4 items

test_one.py::test_serv_open_close PASSED                                                                                                               [ 25%]
test_one.py::test_serv_log PASSED                                                                                                                      [ 50%]
test_one.py::test_serv_basic_request PASSED                                                                                                            [ 75%]
test_one.py::test_serv_get PASSED                                                                                                                      [100%]

===================================================================== 4 passed in 8.07s ======================================================================
[100%] Built target run
(myenv)  [] ~/Templates/lrn/cpp

"""



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

def test_serv_log():
    time.sleep(2)                   #  1sec
    f = 'hi.log'
    # Remove file if exists
    Path(f).unlink(missing_ok=True)

    p = Popen(['./myexe'],stdin=PIPE,stdout=PIPE,stderr=PIPE,text=True)
    o,e = p.communicate('\n')         # send a \n and wait for completion
    print(f'OUT--------------------------------------------------')
    print(o)
    print(f'ERR--------------------------------------------------')
    print(e)

    assert p.returncode == 0
    assert Path(f).exists()
    # now can be read

    i = open(f).read()                 # default to read
    assert re.fullmatch(r'2023-\d{1,}-\d{1,} (.*): <debug> \[AAA\] This will go to hi.log\n', i)


import requests #pip install requests
import json
url = 'http://localhost:7777/'

def test_serv_basic_request():
    time.sleep(2)                   #  1sec
    f = 'hi.log'
    # Remove file if exists
    Path(f).unlink(missing_ok=True)

    p = Popen(['./myexe'],stdin=PIPE,stdout=PIPE,stderr=PIPE,text=True)

    # send request --------------------------------------------------
    result = requests.get(url + 'aaa')
    assert result.ok

    # stop server--------------------------------------------------
    o,e = p.communicate('\n')         # send a \n and wait for completion
    print(f'OUT--------------------------------------------------')
    print(o)
    print(f'ERR--------------------------------------------------')
    print(e)

    assert p.returncode == 0
    assert Path(f).exists()
    # now can be read

    i = open(f).read()                 # default to read
    assert re.fullmatch(r'2023-\d{1,}-\d{1,} (.*): <debug> \[AAA\] This will go to hi.log\n', i)





def test_serv_get():
    time.sleep(2)                   #  1sec
    f = 'hi.log'
    # Remove file if exists
    Path(f).unlink(missing_ok=True)

    p = Popen(['./myexe'],stdin=PIPE,stdout=PIPE,stderr=PIPE,text=True)

    # send request --------------------------------------------------
    result = requests.get(url)
    assert result.ok
    r = json.loads(result.content)
    assert r['x'] == 'target / is not known to GET-server'


    # stop server--------------------------------------------------
    o,e = p.communicate('\n')         # send a \n and wait for completion
    print(f'OUT--------------------------------------------------')
    print(o)
    print(f'ERR--------------------------------------------------')
    print(e)

    assert p.returncode == 0
    assert Path(f).exists()
    # now can be read

    i = open(f).read()                 # default to read
    assert re.fullmatch(r'2023-\d{1,}-\d{1,} (.*): <debug> \[AAA\] This will go to hi.log\n', i)
