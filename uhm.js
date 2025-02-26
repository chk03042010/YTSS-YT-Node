$ npm install firebase
// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
  apiKey: "AIzaSyBJ66xtcM4Qu0NpeQj4Ls7GXTnJxI6chus",
  authDomain: "ytnode-685c7.firebaseapp.com",
  projectId: "ytnode-685c7",
  storageBucket: "ytnode-685c7.firebasestorage.app",
  messagingSenderId: "1028370444934",
  appId: "1:1028370444934:web:332ece423ad18401709707",
  measurementId: "G-R4W6HR07RT"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);




// cli install
$ npm install -g firebase-tools

// misc
$ firebase login
$ firebase init
$ firebase deploy
