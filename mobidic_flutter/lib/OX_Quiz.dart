import 'package:flutter/material.dart';

class OXQuizPage extends StatefulWidget {
  const OXQuizPage({super.key}); // 라우터용 const 생성자

  @override
  State<OXQuizPage> createState() => _OXQuizPageState();
}

class _OXQuizPageState extends State<OXQuizPage> {
  final List<Map<String, dynamic>> quizList = [
    {'word': 'Apple', 'meaning': '사과', 'isCorrect': true},
    {'word': 'Dog', 'meaning': '고양이', 'isCorrect': false},
    {'word': 'Car', 'meaning': '자동차', 'isCorrect': true},
  ];

  int currentIndex = 0;

  void _checkAnswer(bool userAnswer) {
    bool correctAnswer = quizList[currentIndex]['isCorrect'];

    if (userAnswer == correctAnswer) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("정답입니다!! 🎉"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  if (currentIndex < quizList.length - 1) {
                    currentIndex++;
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("퀴즈 완료!")),
                    );
                  }
                });
              },
              child: const Text("다음 문제"),
            )
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("다시 생각해보세요 ㅠ"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("확인"),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentQuiz = quizList[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('O X 퀴즈'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48),
        child: Column(
          children: [
            Text(
              currentQuiz['word'],
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              currentQuiz['meaning'],
              style: const TextStyle(fontSize: 24, color: Colors.grey),
            ),
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _checkAnswer(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: const Text('O', style: TextStyle(fontSize: 24)),
                ),
                ElevatedButton(
                  onPressed: () => _checkAnswer(false),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: const Text('X', style: TextStyle(fontSize: 24)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
