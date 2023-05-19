
from pyrogram import enums, types


class CountAllMyMessagesPerChats():


    def __init__(self, client) -> None:
        self.myself_id = None
        self.client = client


    async def iter_dm_chats(self):
        my_messages_in_chat_count = 0
        async for dialog in self.client.get_dialogs():
            dialog: types.Dialog = dialog

            if dialog.chat.type != enums.ChatType.PRIVATE:
                print("SKIP NON DM CHAT")
                continue
            print(f"Anallizing chat {dialog.chat.first_name}")

            my_msgs_count = await self.count_my_messages_in_chat(dialog.chat.id)
            print(my_msgs_count)
            my_messages_in_chat_count += my_msgs_count

        print(my_messages_in_chat_count)

    async def count_my_messages_in_chat(self, chat_id):
        count = 0
        async for message in self.client.get_chat_history(chat_id):
            message: types.Message = message

            if message.from_user.id == self.myself_id:
                count += 1
            if count % 50 == 0:
                print(f'tempcount {count}')

        return count

    async def start(self):
        async with self.client:
            print(await self.client.get_dialogs_count())

            myself: types.User = await self.client.get_me()
            self.myself_id = myself.id

            await self.iter_dm_chats()
