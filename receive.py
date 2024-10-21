import os
import requests
import json
import time
import base64
from dotenv import load_dotenv

load_dotenv()

GITHUB_API_KEY = os.getenv('GITHUB_API_KEY')
GIST_ID = os.getenv('GIST_ID')

def clear_receive_file():
    headers = { "Accept": "application/vnd.github+json",
                'Authorization': f'Bearer {GITHUB_API_KEY}',
                "X-GitHub-Api-Version" : "2022-11-28"}
    payload = {
        'files' : {"receive.txt" : {"content" : "@"}}
    }
    response = requests.patch(f'https://api.github.com/gists/{GIST_ID}', headers=headers, data=json.dumps(payload))
    
    if response.status_code != 200:
        print("Failure, ", response.status_code)
        print(response.text)

def receive_output():
    headers = { "Accept": "application/vnd.github+json",
                'Authorization': f'Bearer {GITHUB_API_KEY}',
                "X-GitHub-Api-Version" : "2022-11-28"}
    response = requests.get(f'https://api.github.com/gists/{GIST_ID}', headers=headers)
    
    if response.status_code != 200:
        print("Failure, ", response.status_code)
        print(response.text)
    else:
        content_json = json.loads(response.text)
        content_text = content_json['files']
        if 'receive.txt' in content_text:
            decrypted = base64.b64decode(content_text['receive.txt']['content'])
            if decrypted != "@":
                print(decrypted)
                clear_receive_file()
            

    
    
if __name__ == "__main__":
    while True:
        receive_output()
        time.sleep(1)


    
    