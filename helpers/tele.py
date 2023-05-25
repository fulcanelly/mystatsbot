
import asyncio
from telethon import TelegramClient, events, types
import pprint
import api.tg.posts, api.tg.chats
from api.general import get_chats_to_load_from

pp = pprint.PrettyPrinter(indent = 2)

from config.vars import api_id, api_hash

client = TelegramClient('tele_fulca_nele', api_id, api_hash)


async def init_dialog():
    pass

async def load_chats():
    print()
    me: types.User = await client.get_me()
    print(me.id)
    chats_to_load = get_chats_to_load_from()
    print(chats_to_load)
    while chats_to_load:

        for chat_id in chats_to_load:
            print(f'Chat id {chat_id}:')
            try:
                entity = await client.get_entity(int(chat_id))
            except:
                print('got unwknown user')
                # todo: touch chat
                continue
            async for msg in client.iter_messages(entity):
                msg: types.Message = msg


                sender_id = msg.peer_id.user_id if not msg.from_id else None

                print(f'{sender_id}: {msg.message}')

                api.tg.posts.create(chat_id, msg.id, msg.date, sender_id)

            print()

        chats_to_load = get_chats_to_load_from()

async def update_chat_info():
    async for dialog in client.iter_dialogs():
        entity = dialog.entity
        chat = api.tg.chats.show(entity.id)

        if chat.get('error'):
            continue
        # if not found -> init_dialog

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
    me: types.User = await client.get_me()
    print(me)
    await load_chats()
    return
    await update_chat_info()


with client:
    client.loop.run_until_complete(main())
   # client.run_until_disconnected()

