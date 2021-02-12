
import 'package:flutter/material.dart';
import 'package:flutter_receive_notifications/home_page.dart';
import 'package:flutter_receive_notifications/core/push_notifications_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  PushNotificationManager().configure().whenComplete(() {
    PushNotificationManager().verifyToken();
  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: HomePage(),
    );
  }
}