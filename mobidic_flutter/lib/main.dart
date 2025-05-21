import 'package:flutter/material.dart';
import 'Log_in_page.dart';
import 'Sign_up_page.dart';
import 'ox_quiz.dart';
import 'fill_blank.dart';
import 'dictation.dart';
import 'phonics.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobidic 로그인',
      debugShowCheckedModeBanner: false,
      initialRoute: '/', // 앱 실행 시 지정 클래스부터 시작
      routes: {
        '/': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/quiz': (context) => const OXQuizPage(),
        '/fillblank': (context) => const FillBlankPage(),
        '/dictation': (context) => const DictationQuizPage(),
      },
    );
  }
}