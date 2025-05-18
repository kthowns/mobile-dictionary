import 'package:flutter/material.dart';
import 'Log_in_page.dart';
import 'Sign_up_page.dart';
import 'find_id_page.dart';
import 'find_pw_page.dart';
import 'account_find_home.dart'; // 계정 찾기 선택 화면
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
      initialRoute: '/', // 앱 실행 시 LoginPage부터 시작
      routes: {
        '/': (context) => PhonicsPage(),
        '/signup': (context) => SignUpPage(),
        '/find/id': (context) => const FindIdPage(),
        '/find/pw': (context) => const FindPwPage(),
        '/quiz': (context) => const OXQuizPage(),
        '/fillblank': (context) => const FillBlankPage(),
        '/dictation': (context) => const DictationQuizPage(),
      },
    );
  }
}