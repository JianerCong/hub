  # curl http://localhost:8080/albums \
  #   --include \
  #   --header "Content-Type: application/json" \
  #   --request "POST" \
  #   --data "{'id': '4','title': 'item','artist': 'A4','price': 4.44}"

Invoke-RestMethod -Uri http://localhost:8080/albums

$Url = "http://localhost:8080/albums"
$Body = @{
    id = '4'
    title='my posted item'
    artist='A4'
    price=4.44
}
Invoke-RestMethod -Method 'Post' -Uri $url -Body (ConvertTo-Json $body)
