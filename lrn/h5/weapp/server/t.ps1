$url = "https://myfunction-myservice-cgsyqncxvc.cn-hangzhou.fcapp.run"
Invoke-RestMethod -uri ("$url" + '?aa=123&bb=456')
Invoke-RestMethod -uri ("$url" + '/json')

$body = @{
    id = '4'
    title='my posted item'
    artist='A4'
}
Invoke-RestMethod -Method 'Post' -Uri ("$url" + '/json') -Body (ConvertTo-Json $body)


# test pymongo
$url = "https://their-mtemplate-myservice-gttkrqfcfp.cn-hangzhou.fcapp.run"
Invoke-RestMethod -uri ("$url" + '?name=张1')


# Test the local server --------------------------------------------------
$url = "http://localhost:8080/test"
Invoke-RestMethod -uri ("$url" + '?code=123')

# See the result
$res = (Invoke-RestMethod -uri ("$url" + '?code=a1'))
$res
$res.todos

ConvertTo-Json $res.todos

# Post an item
$body = @{
    openid = 'a2'
    todos = (
        @{name = 't1'
          done = $true
          ddl = '2022-11-11'},
        @{name = 't2'
          done = $false
          ddl = '2022-10-11'}
    )
}
ConvertTo-Json $body
Invoke-RestMethod -Method 'Post' -Uri ("$url") -Body (ConvertTo-Json $body)
