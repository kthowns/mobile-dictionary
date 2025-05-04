import 'package:flutter/material.dart';

import 'OX_Quiz.dart';
import 'MainPage.dart';
import 'list.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobidic 로그인',
      debugShowCheckedModeBanner: false,
      initialRoute: '/', // 앱 실행 시 LoginPage부터 시작
      routes: {
        '/': (context) => VocabularyScreen(),
        '/find': (context) => const AccountFindHome(),
        '/find/id': (context) => const FindIdPage(),
        '/find/pw': (context) => const FindPwPage(),
        '/quiz': (context) => const OXQuizPage(),
        '/fillblank': (context) => const FillBlankPage(),
        '/dictation': (context) => const DictationQuizPage(),
      },
    );
  }
}