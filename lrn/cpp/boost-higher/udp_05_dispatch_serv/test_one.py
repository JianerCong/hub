from subprocess import Popen, PIPE
import time

def close_and_check(p):
    o,e = p.communicate('\n')         # send a \n and wait for completion
    print(f'OUT--------------------------------------------------')
    print(o)
    print(f'ERR--------------------------------------------------')
    print(e)
    assert p.returncode == 0
    return (o,e)

def test_serv_open_close():
    time.sleep(1)                   #  1sec
    # this wait for PIPEs  and port binding/unbinding
    p = Popen(['./serv'],stdin=PIPE,stdout=PIPE,stderr=PIPE,text=True)
    time.sleep(1)                   #  1sec
    close_and_check(p)

import socket


def test_serv_send_requests():
    time.sleep(1)                   #  1sec
    # this wait for PIPEs  and port binding/unbinding
    p = Popen(['./serv', '7778'],stdin=PIPE,stdout=PIPE,stderr=PIPE,text=True)
    time.sleep(2)               #  wait till it's up

    HOST, PORT = "localhost", 7778
    data = "aaa"
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock.sendto(bytes(data + "\n", "utf-8"), (HOST, PORT))

    time.sleep(1)               #  wait for it to be handled

    o,e = close_and_check(p)
    assert 'Invalid datagram format' in o

def test_serv_send_unknown_requests():
    time.sleep(1)                   #  1sec
    HOST, PORT = "localhost", 7779

    # this wait for PIPEs  and port binding/unbinding
    p = Popen(['./serv', f'{PORT}'],stdin=PIPE,stdout=PIPE,stderr=PIPE,text=True)
    time.sleep(2)               #  wait till it's up

    data = "aaa:bbb"
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock.sendto(bytes(data + "\n", "utf-8"), (HOST, PORT))

    time.sleep(1)               #  wait for it to be handled

    o,e = close_and_check(p)
    assert 'unknown target' in o

def test_serv_send_known_requests():
    time.sleep(1)                   #  1sec
    HOST, PORT = "localhost", 7780

    # this wait for PIPEs  and port binding/unbinding
    p = Popen(['./serv', f'{PORT}'],stdin=PIPE,stdout=PIPE,stderr=PIPE,text=True)
    time.sleep(2)               #  wait till it's up

    data = "/abc:bbb:cc"

    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock.sendto(bytes(data, "utf-8"), (HOST, PORT))

    time.sleep(1)               #  wait for it to be handled

    o,e = close_and_check(p)
    assert 'handler received bbb:cc' in o
