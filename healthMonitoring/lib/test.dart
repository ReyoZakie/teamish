import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class TestState extends StatefulWidget {
  const TestState({super.key});

  @override
  State<TestState> createState() => _TestStateState();
}

class _TestStateState extends State<TestState> {

  
  myRequestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  getToken() async {
    String? myToken = await FirebaseMessaging.instance.getToken();
    print("==============================");
    print(myToken);
  }

  @override
  void initState() {
    myRequestPermission();
    getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
