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
                  _showCompletionDialog(); // ✅ 마지막 문제 시 결과 다이얼로그
                }
              });
            },
            child: const Text("다음 문제"),
          ),
        ],
      ),
    );
  }

  void _showCompletionDialog() {
    int wrongAnswers = totalAttempts - correctAnswers;
    double percent = totalAttempts == 0 ? 0 : (correctAnswers / totalAttempts) * 100;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("🎉 퀴즈 완료!"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("총 문제 수: $totalAttempts"),
            Text("정답 수: $correctAnswers"),
            Text("오답 수: $wrongAnswers"),
            Text("정답률: ${percent.toStringAsFixed(1)}%"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("닫기"),
          )
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
      backgroundColor: Colors.white, // ✅ 배경 흰색
      appBar: AppBar(
        title: const Text('O X 퀴즈'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'MOBIDIC',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Center(
              child: Text(
                '제시된 단어의 뜻이 맞는지 OX로 판단해보세요!',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ),
            const SizedBox(height: 30),
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
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey[300],
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              Icon(Icons.note, color: Colors.black),
              Icon(Icons.home, color: Colors.black),
              Icon(Icons.exit_to_app, color: Colors.black),
            ],
          ),
        ),
      ),
    );
  }
}
