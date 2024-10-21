import os
import requests
import json
from dotenv import load_dotenv

load_dotenv()

GITHUB_API_KEY = os.getenv('GITHUB_API_KEY')
GIST_ID = os.getenv('GIST_ID')

def send_command(command):
    headers = { "Accept": "application/vnd.github+json",
                'Authorization': f'Bearer {GITHUB_API_KEY}',
                "X-GitHub-Api-Version" : "2022-11-28"}
    payload = {
        'files' : {"send.txt" : {"content" : command }}
    }
    response = requests.patch(f'https://api.github.com/gists/{GIST_ID}', headers=headers, data=json.dumps(payload))
    
    if response.status_code != 200:
        print("Failure, ", response.status_code)
        print(response.text)

    
if __name__ == "__main__":
    while True:
        command = input("")
        send_command(command)



    
    