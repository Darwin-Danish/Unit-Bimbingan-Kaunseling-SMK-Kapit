import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ubk_app/intro_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ubk_app/home.dart';
import 'package:ubk_app/login_screen.dart';
import 'package:ubk_app/widgets/responsive_container.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDCCoWoXzCrJYVxOewNm5gVKr4SnEgxIp0",
      authDomain: "unit-bimbingan-dan-kaunseling.firebaseapp.com",
      databaseURL: "https://unit-bimbingan-dan-kaunseling-default-rtdb.firebaseio.com",
      projectId: "unit-bimbingan-dan-kaunseling",
      storageBucket: "unit-bimbingan-dan-kaunseling.firebasestorage.app",
      messagingSenderId: "311509674507",
      appId: "1:311509674507:web:c2d93ce36af400a733b50e",
      measurementId: "G-3QR7ETYFMQ"
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UBK SMK Kapit',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      builder: (context, child) {
        // This builder wraps every screen in the app with the responsive container
        return ResponsiveContainer(
          backgroundColor: Colors.grey[200], // Background color for extra space
          contentBackgroundColor: Colors.white, // Content area background
          child: child!,
        );
      },
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // If the user is already logged in
        if (snapshot.hasData) {
          return const HomeScreen();
        }

        // If not logged in, show intro screen
        return const IntroScreen();
      },
    );
  }
}