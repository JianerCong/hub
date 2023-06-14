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
    # assert len(l) == 2
    # 🦜 :  It seems that both \\n and \n is ok in regex
    # assert re.fullmatch('\\d\\d\\d\\d-\\d{1,}-\\d{1,} (.*): <trace> aaa\\n', l[0])
    # assert re.fullmatch('\\d\\d\\d\\d-\\d{1,}-\\d{1,} (.*): <debug> bbb\n', l[1])

    # 🦜 : Use r'' to avoid \\
    # assert re.fullmatch(r'\d\d\d\d-\d{1,}-\d{1,} (.*): <trace> aaa\n', l[0])
    # assert re.fullmatch(r'\d\d\d\d-\d{1,}-\d{1,} (.*): <debug> bbb\n', l[1])


