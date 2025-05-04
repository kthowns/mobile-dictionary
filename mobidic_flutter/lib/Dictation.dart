import 'package:flutter/material.dart';

class DictationQuizPage extends StatefulWidget {
  const DictationQuizPage({super.key});

  @override
  State<DictationQuizPage> createState() => _DictationQuizPageState();
}

class _DictationQuizPageState extends State<DictationQuizPage> {
  final TextEditingController _controller = TextEditingController();

  void _checkAnswer() {
    String input = _controller.text.trim().toLowerCase();

    if (input == 'apple') {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("정답입니다!! 🎉"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("확인"),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("오답입니다. 😢"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("다시 시도"),
            ),
          ],
        ),
      );
    }
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
            const SizedBox(height: 40),

            const Icon(Icons.volume_up, size: 64, color: Colors.deepPurple),

            const SizedBox(height: 24),

            // '정답 입력' 텍스트
            const Text(
              '정답 입력',
              style: TextStyle(fontSize: 20),
            ),

            const SizedBox(height: 24),

            // 네모 박스 (입력창)
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
              onSubmitted: (_) => _checkAnswer(), // 엔터로도 제출
            ),

            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: _checkAnswer,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: const Text("제출하기", style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
