import 'package:flutter/material.dart';

import 'OX_Quiz.dart';
import 'MainPage.dart';
import 'list.dart';

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
        '/': (context) =>  VocabularyScreen(),
        '/oxquiz': (context) => OxQuizPage(),
      },
    );
  }
}