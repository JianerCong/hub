from subprocess import Popen, PIPE
import pathlib
from pathlib import Path
import re

import time
def test_send_abc():
    p = Popen(['./myexe'],stdin=PIPE,stdout=PIPE,stderr=PIPE,text=True)
    o,e = p.communicate('abc\n')         # send a \n and wait for completion
    assert o == 'abc'
    assert p.returncode == 0


def test_send_aaabbb():
    p = Popen(['./myexe'],stdin=PIPE,stdout=PIPE,stderr=PIPE,text=True)
    o,e = p.communicate('aaa bbb\n')         # send a \n and wait for completion
    # It only reads a word
    assert o == 'aaa'
    assert p.returncode == 0
