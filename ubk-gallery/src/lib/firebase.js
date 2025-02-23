import { initializeApp } from "firebase/app";
import { getDatabase } from "firebase/database";
import { getAuth } from "firebase/auth";
import { getStorage } from "firebase/storage";

const firebaseConfig = {
    apiKey: "AIzaSyDCCoWoXzCrJYVxOewNm5gVKr4SnEgxIp0",
    authDomain: "unit-bimbingan-dan-kaunseling.firebaseapp.com",
    databaseURL: "https://unit-bimbingan-dan-kaunseling-default-rtdb.firebaseio.com",
    projectId: "unit-bimbingan-dan-kaunseling",
    storageBucket: "unit-bimbingan-dan-kaunseling.firebasestorage.app",
    messagingSenderId: "311509674507",
    appId: "1:311509674507:web:c2d93ce36af400a733b50e",
    measurementId: "G-3QR7ETYFMQ"
  };

// Initialize Firebase (client-side)
const app = initializeApp(firebaseConfig);

export const db = getDatabase(app);
export const auth = getAuth(app);
export const storage = getStorage(app);
