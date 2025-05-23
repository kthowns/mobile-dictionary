import 'package:flutter/material.dart';
import 'package:mobidic_flutter/view/test/test_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobidic 로그인',
      debugShowCheckedModeBanner: false,
      initialRoute: '/', // 앱 실행 시 지정 클래스부터 시작
      routes: {
        '/': (context) => TestPage(),
      },
    );
  }
}