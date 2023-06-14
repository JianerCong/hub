import pathlib
import subprocess
from pathlib import Path

import re

def test_f():
    f = 'hi.log'
    # Remove file if exists
    Path(f).unlink(missing_ok=True)


    # run the exec
    c = subprocess.run(['./myexe'],
                       capture_output=True, text=True)
    # c is the CompletedProcess class
    assert c.returncode == 0
    assert c.stderr == ''
    assert c.stdout == ''

    # check the file content
    assert Path(f).exists()
    assert open(f).readlines() \
        == [
            '1: <trace> aaa\n',
            '2: <debug> bbb\n',
            ]
    # l = open(f).readlines()
    # assert len(l) == 5
    # assert l[0].startswith('[')
    # assert bool(re.fullmatch('\\[(.*)\\] timmer started\n', l[0]))
    # assert bool(re.fullmatch('\\[(.*)\\] aaa\n', l[1]))
    # assert bool(re.fullmatch('\\[(.*)\\] bbb\n', l[2]))
    # assert bool(re.fullmatch('\\[(.*)\\] timmer ended\n', l[3]))
    # assert bool(re.fullmatch('aaa untimed\n', l[4]))


