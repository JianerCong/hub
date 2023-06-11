$Url = "http://localhost:7777/"
$Body = @{
    id = '4'
    title='my posted item'
    artist='A4'
    price=4.44
}

# POST
Invoke-RestMethod -Method 'Post' -Uri $url `
  -Body (ConvertTo-Json $body) -ContentType 'application/json' `
  -DisableKeepAlive -ResponseHeadersVariable x
$x                              #see the header.

# ❄ By default the connection is kept alive. By adding -DisableKeepAlive, we
# establish a new connection every time.


Invoke-RestMethod -Uri http://localhost:8080/albums -DisableKeepAlive `
  -ResponseHeadersVariable x    #store header in $x
$x                              #see the header
