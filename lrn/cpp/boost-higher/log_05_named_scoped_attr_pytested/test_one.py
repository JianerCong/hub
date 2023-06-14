import pathlib
import subprocess
from pathlib import Path

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
    assert open(f).readlines() == [
        '(s1) scoped-aaa\n',
        '() aaa\n',
    ]


