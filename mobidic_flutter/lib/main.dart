import 'package:flutter/material.dart';
import 'package:mobidic_flutter/login_UI.dart';

import 'OX_Quiz.dart';
import 'join_UI.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Whale Login',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) =>  LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/oxquiz': (context) => OxQuizPage(),
      },
    );
  }
}