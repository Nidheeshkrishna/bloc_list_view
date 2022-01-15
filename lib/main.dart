import 'package:bloc_list_view/features/home/screens/home_Screen.dart';
import 'package:bloc_list_view/features/home/screens/splash.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the bloc of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
      ),
      home: SplashScreen(),
    );
  }
}
