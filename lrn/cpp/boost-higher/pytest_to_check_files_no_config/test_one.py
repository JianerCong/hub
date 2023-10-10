import pathlib
import subprocess
from pathlib import Path

def test_f():
    f = 'hi.log'
    # Remove file if exists
    Path(f).unlink(missing_ok=True)


    # run the exec
    c = subprocess.run(['./myexe'])
    # c is the CompletedProcess class
    assert c.returncode == 0

    # check the file content
    assert Path(f).exists()
    assert open(f).readlines() == ['abc']


