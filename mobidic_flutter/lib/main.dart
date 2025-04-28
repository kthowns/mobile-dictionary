import 'package:flutter/material.dart';
import 'package:mobidic_flutter/Dictation.dart';
import 'login_UI.dart';
import 'join_UI.dart';
import 'Find_id_pw.dart';
import 'OX_Quiz.dart';

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
        '/': (context) =>  Fill_blank(),
        '/signup': (context) => SignUpPage(),
        '/oxquiz': (context) => OxQuizPage(),
      },
    );
  }
}