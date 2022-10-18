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
Invoke-RestMethod -uri ("http://localhost:8080/test" + '?code=123')
