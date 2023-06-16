import pathlib
import subprocess
from pathlib import Path

import re

def test_f():
    f = 'hi_1.log'
    # Remove file if exists
    Path(f).unlink(missing_ok=True)


    # run the exec
    c = subprocess.run(['./myexe'],
                       capture_output=True, text=True)
    # c is the CompletedProcess class
    assert c.returncode == 0
    assert c.stderr == ''
    assert c.stdout == ''.join([
        '1: <> aaa\n',
        '2: <ABC> aaa\n'
                        ])

    # check the file content
    assert Path(f).exists()
    assert open(f).readlines() \
        == [
            '1: <trace> aaa\n',
            '2: <debug> bbb\n',
            ]
