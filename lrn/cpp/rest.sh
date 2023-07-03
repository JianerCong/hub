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

