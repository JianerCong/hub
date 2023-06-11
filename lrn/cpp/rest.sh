Url = "http://localhost:7777/"

# Post

# --include : include header in the output
curl $Url --include --data "{'id': '4','title': 'item','artist': 'A4','price': 4.44}" -H "content-type: application/json"
