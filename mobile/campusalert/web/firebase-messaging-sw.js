importScripts("https://www.gstatic.com/firebasejs/9.6.10/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/9.6.10/firebase-messaging-compat.js");

// todo Copy/paste firebaseConfig from Firebase Console
const firebaseConfig = {
 apiKey: "...",
 authDomain: "...",
 databaseURL: "...",
 projectId: "...",
 storageBucket: "...",
 messagingSenderId: "...",
 appId: "...",
};

firebase.initializeApp(firebaseConfig);
const messaging = firebase.messaging();


messaging.onBackgroundMessage((message) => {
    console.log("onBackgroundMessage", message);
   });
   