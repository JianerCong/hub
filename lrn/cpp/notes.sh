Url="http://localhost:7777/"
curl http://localhost:7777/aaa
# Post

# --include : include header in the output
curl $Url \
     --include \
     --data "{'id': '4','title': 'item','artist': 'A4','price': 4.44}" \
     -H "content-type: application/json" \
     --no-keepalive
# By default, when --data is present, curl makes it a POST request
# so ~-X POST~ is unnecessary.


# curl https://randomuser.me/api/?nat=gb,ch&results=3&inc=name,nat&seed=abc
curl "https://randomuser.me/api/?nat=gb,ch&results=3&inc=name,nat&seed=abc"
curl "https://randomuser.me/api/?inc=name,nat?nat=ch&results=3"


rm ./build-hi -rf && cmake -S ./boost-higher/udp_05_dispatch_serv/ -B ./build-hi
cmake --build build-hi
python ./build-hi/clnt.py

cd boost-higher
rm udp_05_dispatch_serv/clnt.py
ln -s $(pwd)/udp_03_q_to_quit_serv/clnt.py udp_04_serv_class/clnt.py
ln -s $(pwd)/udp_03_q_to_quit_serv/clnt.py udp_05_dispatch_serv/clnt.py

./build-hi/serv

python ./build-hi/clnt.py
