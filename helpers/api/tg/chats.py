
import requests

base_url = 'http://localhost:3000/api/v1/chats'

def all():
    response = requests.get(f"{base_url}")
    return response.json()

def show(chat_id):
    response = requests.get(f"{base_url}/{chat_id}")
    return response.json()

def create(chat_data):
    response = requests.post(f"{base_url}", json=chat_data)
    if response.status_code == 201:
        return response.json()
    else:
        raise Exception(f"Failed to create chat: {response.text}")

def update(chat_id, chat_data):
    response = requests.put(f"{base_url}/{chat_id}", json=chat_data)
    if response.status_code == 200:
        return response.json()
    else:
        raise Exception(f"Failed to update chat: {response.text}")
