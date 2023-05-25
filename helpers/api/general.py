


import requests


def get_chats_to_load_from():
    base_url = 'http://localhost:3000/api/v1/messages_loads/chats_to_load_from'
    response = requests.get(f"{base_url}")
    return response.json()
