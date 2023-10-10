
$Url = "http://172.31.36.51:7777/upload/hi.json"
$Body = @{
    id = '4'
    title='my posted item'
    artist='A4'
    price=4.44
}
# POST
Invoke-RestMethod -Method 'Post' -Uri $url `
  -Body (ConvertTo-Json $body) -ContentType 'application/json'
