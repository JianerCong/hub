Invoke-RestMethod -Uri http://localhost:8080/
Invoke-RestMethod -Uri http://localhost:8080/q?a=1&b=cc
Invoke-RestMethod -Uri http://localhost:8080/json

$Url = "http://localhost:8080/json"
$Body = @{
    id = '4'
    title='my posted item'
    artist='A4'
    price=4.44
}
Invoke-RestMethod -Method 'Post' -Uri $url -Body (ConvertTo-Json $body)
