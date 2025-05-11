import 'package:flutter/material.dart';

class DictationQuizPage extends StatefulWidget {
  const DictationQuizPage({super.key});

  @override
  State<DictationQuizPage> createState() => _DictationQuizPageState();
}

class _DictationQuizPageState extends State<DictationQuizPage> {
  final TextEditingController _controller = TextEditingController();

  final List<String> answers = ['apple', 'blue', 'call'];
  int currentIndex = 0;
  int correctCount = 0;
  int totalCount = 0;

  void _checkAnswer() {
    String input = _controller.text.trim().toLowerCase();
    String correctAnswer = answers[currentIndex];

    bool isCorrect = input == correctAnswer;
    setState(() {
      totalCount++;
      if (isCorrect) correctCount++;
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
                if (currentIndex < answers.length - 1) {
                  currentIndex++;
                  _controller.clear();
                } else {
                  _showCompletionDialog();
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
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("🎉 퀴즈 완료!"),
        content: Text("총 정답률: ${_getAccuracyText()}"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("닫기"),
          )
        ],
      ),
    );
  }

  String _getAccuracyText() {
    if (totalCount == 0) return "0% (0 / 0)";
    double percent = (correctCount / totalCount) * 100;
    return "${percent.toStringAsFixed(1)}% ($correctCount / $totalCount)";
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
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0, right: 16.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                '정답률: ${_getAccuracyText()}',
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFb2ebf2),
              Color(0xFF81d4fa),
              Color(0xFF4fc3f7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Icon(Icons.volume_up, size: 64, color: Colors.blue),
              const SizedBox(height: 24),
              const Text('정답 입력', style: TextStyle(fontSize: 20)),
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
              ElevatedButton(
                onPressed: _checkAnswer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: const Text(
                  "제출하기",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
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
