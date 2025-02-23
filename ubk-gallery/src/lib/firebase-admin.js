import admin from 'firebase-admin';
import serviceAccount from './firebase-admin.json';

if (!admin.apps.length) {
  try {
    admin.initializeApp({
      credential: admin.credential.cert(serviceAccount),
      databaseURL: "https://unit-bimbingan-dan-kaunseling-default-rtdb.firebaseio.com"
    });
  } catch (error) {
    console.log('Firebase admin initialization error', error.stack);
  }
}

export const db = admin.database();
export const auth = admin.auth();
export const storage = admin.storage();