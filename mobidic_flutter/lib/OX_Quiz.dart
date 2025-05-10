import 'package:flutter/material.dart';

class OXQuizPage extends StatefulWidget {
  const OXQuizPage({super.key});

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
  int correctAnswers = 0;
  int totalAttempts = 0;

  void _checkAnswer(bool userAnswer) {
    bool correctAnswer = quizList[currentIndex]['isCorrect'];
    bool isCorrect = userAnswer == correctAnswer;

    setState(() {
      totalAttempts++;
      if (isCorrect) correctAnswers++;
    });

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isCorrect ? "정답입니다!! 🎉" : "오답입니다. 😢"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                if (currentIndex < quizList.length - 1) {
                  currentIndex++;
                } else {
                  // 퀴즈 종료 메시지
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("퀴즈 완료!")),
                  );
                }
              });
            },
            child: const Text("다음 문제"),
          ),
        ],
      ),
    );
  }

  String getAccuracyText() {
    if (totalAttempts == 0) return "정답률: 0%";
    double percent = (correctAnswers / totalAttempts) * 100;
    return "정답률: ${percent.toStringAsFixed(1)}% ($correctAnswers / $totalAttempts)";
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                getAccuracyText(),
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 40),
            Center(
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
                ],
              ),
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
            ),
            const SizedBox(height: 40),
            if (currentIndex == quizList.length - 1 && totalAttempts == quizList.length)
              const Center(
                child: Text(
                  "🎉 퀴즈 완료!",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
