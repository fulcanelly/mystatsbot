import requests

# API base URL
base_url = 'http://localhost:3000/api/v1/'

# # GET request to retrieve all TG posts
# def get_tg_posts():
#     url = base_url + 'tg_posts'
#     response = requests.get(url)
#     if response.status_code == 200:
#         tg_posts = response.json()
#         print("TG Posts:")
#         for tg_post in tg_posts:
#             print(f"ID: {tg_post['id']}, TG Post ID: {tg_post['tg_post_id']}")
#     else:
#         print(f"Error: {response.status_code}")

# POST request to create a new TG post

def create(tg_post_id, serialized_date):
    url = 'http://localhost:3000/api/v1/tg_posts'
    payload = {
        'tg_post': {
            'tg_post_id': tg_post_id
        },
        'serialized_date': str(serialized_date)
    }
    response = requests.post(url, json=payload)

    if response.status_code == 201:
        print('TgPost created successfully.')
        print('TgPost ID:', response.json()['id'])
    else:
        print('Failed to create TgPost.')
        print('Error:', response.text)

# # PUT request to update an existing TG post
# def update_tg_post(tg_post_id, new_day_id):
#     url = base_url + f'tg_posts/{tg_post_id}'
#     payload = {
#         'tg_post': {
#             'day_id': new_day_id
#         }
#     }
#     response = requests.put(url, json=payload)
#     if response.status_code == 200:
#         tg_post = response.json()
#         print(f"TG Post updated - ID: {tg_post['id']}, New Day ID: {tg_post['day_id']}")
#     else:
#         print(f"Error: {response.status_code}")

# # DELETE request to delete a TG post
# def delete_tg_post(tg_post_id):
#     url = base_url + f'tg_posts/{tg_post_id}'
#     response = requests.delete(url)
#     if response.status_code == 204:
#         print("TG Post deleted successfully")
#     else:
#         print(f"Error: {response.status_code}")

# # Example usage
# # get_tg_posts()
# create_tg_post("TG123", 1)
# update_tg_post(1, 2)
# delete_tg_post(1)
