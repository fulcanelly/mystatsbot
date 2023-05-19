from pyrogram import Client, filters

from datetime import datetime
from vars import api_id, api_hash


app = Client('fulcanelly', api_id, api_hash)

#flow
#/search


@app.on_message(filters.all & filters.private)
async def on_message(client, event):
    print("got message nah:")


app.on_raw_update()
async def on_raw(_, event):
    print(f"RAW {event}")


async def main():
    async with app:
        await app.send_message('me', 'starting at ' + str(datetime.now()))


app.run(main())
app.run()
