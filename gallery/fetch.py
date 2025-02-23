from telethon.sync import TelegramClient

api_id = "22013333"
api_hash = "2e3777b23e3db284bf0e6241428a1ac3"

client = TelegramClient("session", api_id, api_hash)

async def print_photo_messages(channel):
    async for message in client.iter_messages(channel):
        if message.photo:
            print("Photo message:", message)

with client:
    client.loop.run_until_complete(print_photo_messages("luminaTestChannel"))
