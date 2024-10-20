import os
import requests
import xml.etree.ElementTree as ET
import time
from dotenv import load_dotenv

load_dotenv()

PASTEBIN_USERAME=os.getenv('PASTEBIN_USERNAME')
PASTEBIN_PASSWORD=os.getenv('PASTEBIN_PASSWORD')
PASTEBIN_DEV_API_KEY=os.getenv('PASTEBIN_DEV_API_KEY')
PASTEBIN_USER_API_KEY=os.getenv('PASTEBIN_USER_API_KEY')


def get_paste_key():
    payload={
        'api_dev_key' : PASTEBIN_DEV_API_KEY,
        'api_user_key' : PASTEBIN_USER_API_KEY,
        'api_option' : 'list'
    }
    response = requests.post("https://pastebin.com/api/api_post.php", data=payload)
    if response.status_code == 200:
        xml = ET.fromstring('<root>' + response.text + '</root>')
        result = xml.findall(".//paste[paste_title='receive']/paste_key")
        return result[0].text if len(result) > 0 else None
    else:
        print("Error: not able to get pastes of user", response.status_code)
        return None
    

def receive_paste_text(api_paste_key):
    payload = {
        "api_dev_key" : PASTEBIN_DEV_API_KEY,
        "api_user_key" : PASTEBIN_USER_API_KEY,
        "api_paste_key" : api_paste_key,
        "api_option" : 'show_paste'
    }

    response = requests.post("https://pastebin.com/api/api_raw.php", data=payload)

    if response.status_code == 200:
        print(response.text)
        
def delete_paste(paste_key):
    payload = {
        "api_dev_key" : PASTEBIN_DEV_API_KEY,
        "api_user_key" : PASTEBIN_USER_API_KEY,
        "api_paste_key" : paste_key,
        "api_option" : 'delete'
    }

    response = requests.post("https://pastebin.com/api/api_post.php", data=payload)
    return response.status_code == 200

def receive_commands():
    print("Polling every 1 second(s), Press Ctrl+C to quit")
    while True:
        receive_paste_key = get_paste_key()
        if receive_paste_key != None:
            receive_paste_text(receive_paste_key)
            delete_paste(receive_paste_key)
        time.sleep(1)
    
if __name__ == "__main__":
    receive_commands()


    
    