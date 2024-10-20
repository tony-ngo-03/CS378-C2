import os
import requests
from dotenv import load_dotenv

load_dotenv()

PASTEBIN_USERAME=os.getenv('PASTEBIN_USERNAME')
PASTEBIN_PASSWORD=os.getenv('PASTEBIN_PASSWORD')
PASTEBIN_DEV_API_KEY=os.getenv('PASTEBIN_DEV_API_KEY')



if __name__ == '__main__':
    request_payload={
        "api_dev_key" : PASTEBIN_DEV_API_KEY,
        "api_user_name" : PASTEBIN_USERAME,
        "api_user_password" : PASTEBIN_PASSWORD
    }

    response = requests.post("https://pastebin.com/api/api_login.php", data=request_payload)

    if response.status_code == 200:
        print("Successfully created user API Key: ", end="")
        print(response.text)
    else:
        print("Error: Did not create user API Key,", response.status_code)