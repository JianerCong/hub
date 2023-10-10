# Echo server program
import socket

HOST = '::1'                 # ipv6 localhost
PORT = 7777              # Arbitrary non-privileged port

# create an IPv6 socket
with socket.socket(socket.AF_INET6, socket.SOCK_STREAM) as s:
    # s.bind((HOST, PORT,0,1))    # the 0 and 1 are the flow info and scope id.
    s.bind((HOST, PORT,0,3)) # 3 means the wireless interface
    print('Listening on port', PORT)
    s.listen(1)
    conn, addr = s.accept()
    with conn:
        print('Connected by', addr)
        while True:
            data = conn.recv(1024)
            if not data: break
            conn.sendall(data)
