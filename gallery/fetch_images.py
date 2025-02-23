from telethon import TelegramClient
from gallery.firebase_config import get_db
from datetime import datetime

API_ID = '22013333'
API_HASH = '2e3777b23e3db284bf0e6241428a1ac3'
CHANNEL_USERNAME = 'luminaTestChannel'
client = TelegramClient('testUBK', API_ID, API_HASH)

async def fetch_images():
    await client.start()
    db_ref = get_db()

    async for message in client.iter_messages(CHANNEL_USERNAME):
        if message.media:
            # Extract Date, Month, Year
            msg_date = message.date.strftime("%d %B %Y")  # Example: "01 March 2025"
            month = message.date.strftime("%B")  # Example: "March"
            year = message.date.strftime("%Y")  # Example: "2025"

            # Save to Firebase
            db_ref.child("gallery").child(year).child(month).push({
                "file_id": message.media.document.id,
                "date": msg_date,
                "title": message.text.split("\n")[0] if message.text else "No Title",
                "caption": "\n".join(message.text.split("\n")[1:]) if message.text else ""
            })

with client:
    client.loop.run_until_complete(fetch_images())
