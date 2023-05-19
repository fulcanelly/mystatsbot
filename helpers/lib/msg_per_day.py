
from pyrogram import enums, types

from pyrogram import Client, filters

class AllMyMessages():
    def __init__(self, client: Client, handler) -> None:
        self.myself_id = None
        self.client = client
        self.handler = handler

    async def iter_dm_chats(self):
        async for dialog in self.client.get_dialogs():
            dialog: types.Dialog = dialog

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


