
import asyncio
from telethon import TelegramClient, events
import pprint
import api.tg.posts, api.tg.chats

pp = pprint.PrettyPrinter(indent = 2)

from config.vars import api_id, api_hash

client = TelegramClient('tele_fulca_nele', api_id, api_hash)


async def update_chat_info():
    async for dialog in client.iter_dialogs():
        entity = dialog.entity
        chat = api.tg.chats.show(entity.id)

        if chat.get('error'):
            continue

        if not chat['first_name'] and not chat['is_deleted']:
            pp.pprint(chat)
            print(entity)

            api.tg.chats.update(entity.id, {
                'first_name': entity.first_name,
                'username': entity.username,
                'is_deleted': entity.deleted
            })
            print()


async def main():
    await update_chat_info()


with client:
    client.loop.run_until_complete(main())
   # client.run_until_disconnected()

