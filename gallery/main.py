from fastapi import FastAPI
from telethon import TelegramClient
from telethon.tl.types import MessageMediaPhoto
import firebase_admin
from firebase_admin import credentials, db
from datetime import datetime

# CONFIGURATION
API_ID = "22013333"
API_HASH = "2e3777b23e3db284bf0e6241428a1ac3"
CHANNEL_USERNAME = "luminaTestChannel"
FIREBASE_JSON = "firebase-admin.json"
DATABASE_URL = "https://unit-bimbingan-dan-kaunseling-default-rtdb.firebaseio.com"

# FIREBASE INIT
cred = credentials.Certificate(FIREBASE_JSON)
firebase_admin.initialize_app(cred, {"databaseURL": DATABASE_URL})
db_ref = db.reference("/gallery")

# TELEGRAM CLIENT
client = TelegramClient("session", API_ID, API_HASH)

# FETCH IMAGES FROM TELEGRAM
async def fetch_images():
    await client.start()
    async for message in client.iter_messages(CHANNEL_USERNAME):
        if message.media:
            msg_date = message.date.strftime("%d %B %Y")
            month = message.date.strftime("%B")
            year = message.date.strftime("%Y")

            # Handle both photos and other media types
            if isinstance(message.media, MessageMediaPhoto):
                file_id = message.photo.id
                media_type = "photo"
            elif hasattr(message.media, 'document'):
                file_id = message.media.document.id
                media_type = "document"
            else:
                continue  # Skip if it's neither a photo nor a document
            db_ref.child(year).child(month).push({
                "file_id": str(file_id),
                "media_type": media_type,
                "date": msg_date,
                "title": message.text.split("\n")[0] if message.text else "No Title",
                "caption": "\n".join(message.text.split("\n")[1:]) if message.text else ""
            })
    print("✅ Images saved to Firebase")

# API TO FETCH DATA FOR FRONTEND
app = FastAPI()

@app.get("/gallery")
def get_gallery():
    return db_ref.get() or {}

# RUN TELEGRAM FETCH
with client:
    client.loop.run_until_complete(fetch_images())

# RUN API: uvicorn main:app --reload
