import 'package:flutter/material.dart';

class DictationQuizPage extends StatefulWidget {
  const DictationQuizPage({super.key});

  @override
  State<DictationQuizPage> createState() => _DictationQuizPageState();
}

class _DictationQuizPageState extends State<DictationQuizPage> {
  final TextEditingController _controller = TextEditingController();

  // 정답 통계용 상태
  int totalAttempts = 0;
  int correctAnswers = 0;

  void _checkAnswer({bool skipped = false}) {
    String input = _controller.text.trim().toLowerCase();

    setState(() {
      totalAttempts++;
    });

    bool isCorrect = !skipped && input == 'apple';

    if (isCorrect) {
      setState(() {
        correctAnswers++;
      });
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isCorrect ? "정답입니다!! 🎉" : "오답입니다. 😢"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _controller.clear(); // 입력창 비우기
            },
            child: const Text("다음"),
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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('받아쓰기 퀴즈'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // 정답률 표시
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                getAccuracyText(),
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),

            const SizedBox(height: 20),

            const Icon(Icons.volume_up, size: 64, color: Colors.deepPurple),

            const SizedBox(height: 24),

            const Text(
              '정답 입력',
              style: TextStyle(fontSize: 20),
            ),

            const SizedBox(height: 24),

            TextField(
              controller: _controller,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24),
              decoration: InputDecoration(
                hintText: '여기에 입력하세요',
                contentPadding: const EdgeInsets.symmetric(vertical: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: (_) => _checkAnswer(),
            ),

            const SizedBox(height: 32),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _checkAnswer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: const Text("제출하기", style: TextStyle(fontSize: 18)),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => _checkAnswer(skipped: true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  ),
                  child: const Text("모르겠어요", style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
