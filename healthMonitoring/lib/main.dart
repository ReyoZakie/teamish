import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:healthmonitoring/components/add.dart';
import 'package:healthmonitoring/homepage.dart';
import 'package:healthmonitoring/login.dart';
import 'package:healthmonitoring/signup.dart';
import 'package:healthmonitoring/users.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.

  print("Handling a background message: ${message.messageId}");
}


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('=======================User is currently signed out!');
      } else {
        print('=======================User is signed in!');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
              backgroundColor: Color.fromARGB(255, 30, 4, 46),
              titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
              iconTheme: IconThemeData(
                color: Colors.white, //change your icon color here
              ))),
      debugShowCheckedModeBanner: false,
      //if the user is signed in and his email is verified then go to homepage
      //otherwise go to login page
      home: FirebaseAuth.instance.currentUser == null
          ? const Login()
          : const Homepage(),
      routes: {
        'signup': (context) => const Signup(),
        'login': (context) => const Login(),
        'homepage': (context) => const Homepage(),
        'addfile': (context) => const AddFile(),
        'userfilter': (context) => const UsersFilter(),
      },
    );
  }
}