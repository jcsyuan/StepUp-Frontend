import requests

r = requests.get('http://localhost:5000/person')
body = r.json()

first = ''
for result in body['results']:
    if result['place'] == 1:
        first = result['name']

print(f'{first} is in.')
