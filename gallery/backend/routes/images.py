from fastapi import FastAPI
from firebase_config import get_db

app = FastAPI()

@app.get("/gallery")
def get_gallery():
    db_ref = get_db()
    gallery_data = db_ref.child("gallery").get()
    return gallery_data or {}
