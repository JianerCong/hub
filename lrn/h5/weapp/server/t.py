# parse url
from urllib.parse import parse_qs

q = 'aa=123&bb=456'
dict_result = parse_qs(q,keep_blank_values=True)
print(dict_result)
print(dict_result['aa'][0])
print(dict_result['bb'][0])
