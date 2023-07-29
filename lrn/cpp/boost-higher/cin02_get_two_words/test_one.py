from subprocess import Popen, PIPE
import pathlib
from pathlib import Path
import re

import time
def test_send_abc():
    p = Popen(['./myexe'],stdin=PIPE,stdout=PIPE,stderr=PIPE,text=True)
    o,e = p.communicate('aaa bbb\n')         # send a \n and wait for completion
    assert o == 'aaa bbb'
    assert p.returncode == 0
