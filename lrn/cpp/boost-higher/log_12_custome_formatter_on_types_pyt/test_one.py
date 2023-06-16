import pathlib
import subprocess
from pathlib import Path

import re

def test_f():
    # run the exec
    c = subprocess.run(['./myexe'],
                       capture_output=True, text=True)
    # c is the CompletedProcess class
    assert c.returncode == 0
    assert c.stdout == ''
    assert c.stderr == ''.join([
        '1: <> aaa\n',
        '2: <ABC> aaa\n'
                        ])
