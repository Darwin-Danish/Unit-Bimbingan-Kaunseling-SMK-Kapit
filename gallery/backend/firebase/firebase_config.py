import firebase_admin
from firebase_admin import credentials, db

# Initialize Firebase
cred = credentials.Certificate("./firebase-admin.json")
firebase_admin.initialize_app(cred, {"databaseURL": "https://unit-bimbingan-dan-kaunseling-default-rtdb.firebaseio.com"})

def get_db():
    return db.reference("/")
