import asyncio
from pyrogram import Client, filters

from datetime import datetime
from config.vars import api_id, api_hash

from pyrogram import types, raw, utils, enums
from lib.msg_per_day import AllMyMessages

from lib.all_my_messages import CountAllMyMessagesPerChats
import api.tg_posts

client = Client('fulcanelly2', api_id, api_hash)


# TODO: special cases channels where am i admin
# TODO: skip channel where i not admin
# TODO find most reacted recent messages (comments), reproduce clickbait ely,by

def retry_decorator(func):
    async def wrapped_func(*args, **kwargs):
        retry_delay = 3
        attempts = 0

        while True:
            try:
                return await func(*args, **kwargs)
            except:
                attempts += 1

                print(f"Attempt {attempts}: Retrying after {retry_delay} seconds...")

                await asyncio.sleep(retry_delay)

    return wrapped_func


@retry_decorator
async def retry_get_chat_cnt(chat_id):
    async for message in client.get_chat_history(chat_id):
        message: types.Message = message

        print(message.from_user.id)

    return 0

async def get_dialogs_and_count_messages():
    chat_count = 0
    msg_count = 0


    async with client:
        myself: types.User = client.get_me()

        return
        async for dialog in client.get_dialogs(limit=15):
            if dialog.chat.type != enums.ChatType.PRIVATE:
                print("SKIP NON DM CHAT")
                continue

            dialog: types.Dialog = dialog

            print(dialog.chat.username)
            msg_count += await retry_get_chat_cnt(dialog.chat.id)

            print(dialog.chat.type)
            chat_count += 1
            print()

    print(chat_count)
    print(msg_count)

print(CountAllMyMessagesPerChats)

# api.tg_posts.create('a:3443', datetime.today())
# api.tg_posts.create('a23:3443', datetime.today())
# api.tg_posts.create('a232:3443', datetime.today())

# TODO csv
# TODO
        # if dialog.chat.type in ('user', 'supergroup'):
        #     chat_id = dialog.chat.id
        #     async for message in client.search_messages(chat_id, filter=user_filter):
        #         count_messages(message)
#client.run(ChatStatsCollector().start())
def handle_message(message: types.Message):
    api.tg_posts.create(message.chat.id, message.id, message.date)


class CountMessagesPerDays():

    def __init__(self, client: Client, handler) -> None:
        self.myself_id = None
        self.client = client
        self.handler = handler



    async def iter_dm_chats(self):
        async for dialog in self.client.get_dialogs():
            dialog: types.Dialog = dialog


            if dialog_have_at_leat_one_log:
                print("SKIPPING CHAT SINSE IT ALREADY BEEN HANDLED: rehadnle latter")
                continue

            if dialog.chat.type != enums.ChatType.PRIVATE:
                print("SKIP NON-DM CHAT")
                continue

            print(f"Analyzing chat: {dialog.chat.first_name}")

            await self.handle_my_messages_in_chat(dialog.chat.id)


    async def handle_my_messages_in_chat(self, chat_id):
        count = 0
        async for message in self.client.get_chat_history(chat_id):
            message: types.Message = message

            if message.from_user.id == self.myself_id:
                count += 1
                self.handler(message)
            if count % 50 == 0:
                print(f'Handled messages in chat: {count}')

        return count

    async def start(self):
        async with self.client:
            print(await self.client.get_dialogs_count())

            myself: types.User = await self.client.get_me()
            self.myself_id = myself.id

            await self.iter_dm_chats()




client.run(AllMyMessages(client, handle_message).start())
