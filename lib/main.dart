import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyA-5nu6g8-3he9KnhTi5riXe0fnMZSDbEk",
        authDomain: "doanckuddddnt.firebaseapp.com",
        projectId: "doanckuddddnt",
        storageBucket: "doanckuddddnt.firebasestorage.app",
        messagingSenderId: "662979389508",
        appId: "1:662979389508:web:48c795d8e0e6a57beb7411",
        measurementId: "G-FRHHNXDQS2"
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(App());
}
 