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
    int wrongCount = totalCount - correctCount;
    double percent =
    totalCount == 0 ? 0 : (correctCount / totalCount) * 100;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("🎉 퀴즈 완료!"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("총 문제 수: $totalCount"),
            Text("정답 수: $correctCount"),
            Text("오답 수: $wrongCount"),
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
      backgroundColor: Colors.white, // 흰 배경
      appBar: AppBar(
        title: const Text('MOBIDIC'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0, right: 16.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                '정답률: ${_getAccuracyText()}',
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(
              child: Text(
                '받아쓰기 퀴즈',
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
                '들려주는 단어를 듣고 정확히 입력해보세요!',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ),
            const SizedBox(height: 40),
            const Icon(Icons.volume_up, size: 64, color: Colors.blue),
            const SizedBox(height: 24),
            const Text('단어 듣기', style: TextStyle(fontSize: 20, color: Colors.black)),
            const SizedBox(height: 24),
            TextField(
              controller: _controller,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, color: Colors.black),
              decoration: InputDecoration(
                hintText: '들리는 단어를 입력하세요',
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
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: const Text(
                "제출하기",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
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
