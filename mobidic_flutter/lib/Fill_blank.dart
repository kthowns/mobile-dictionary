import 'package:flutter/material.dart';

class FillBlankPage extends StatefulWidget {
  const FillBlankPage({super.key});

  @override
  State<FillBlankPage> createState() => _FillBlankPageState();
}

class _FillBlankPageState extends State<FillBlankPage> {
  final List<Map<String, dynamic>> quizList = [
    {
      'word': 'apple',
      'meaning': '사과',
      'revealed': [false, false, false, true, true],
    },
    {
      'word': 'cat',
      'meaning': '고양이',
      'revealed': [false, false, false],
    },
    {
      'word': 'human',
      'meaning': '사람',
      'revealed': [false, true, false, false, true],
    },
  ];

  int currentIndex = 0;
  List<String> userInput = [];
  List<TextEditingController> controllers = [];
  int totalAttempts = 0;
  int correctAnswers = 0;

  @override
  void initState() {
    super.initState();
    _setupCurrentQuestion();
  }

  void _setupCurrentQuestion() {
    final quiz = quizList[currentIndex];
    userInput = List.generate(quiz['word'].length, (_) => '');
    controllers = List.generate(
      quiz['word'].length,
          (_) => TextEditingController(),
    );
  }

  void checkAnswer() {
    final quiz = quizList[currentIndex];
    final String word = quiz['word'];
    final List<bool> revealed = quiz['revealed'];

    String answer = '';
    for (int i = 0; i < word.length; i++) {
      answer += revealed[i] ? word[i] : userInput[i].toLowerCase();
      answer += revealed[i] ? word[i] : userInput[i].toLowerCase();
    }

    bool isCorrect = answer == word;

    setState(() {
      totalAttempts++;
      if (isCorrect) correctAnswers++;
    });

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isCorrect ? '정답입니다!! 🎉' : '오답입니다. 😢'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (currentIndex < quizList.length - 1) {
                setState(() {
                  currentIndex++;
                  _setupCurrentQuestion();
                });
              } else {
                _showSummaryDialog();
              }
            },
            child: const Text("다음 문제"),
          ),
        ],
      ),
    );
  }

  void _showSummaryDialog() {
    int wrongAnswers = totalAttempts - correctAnswers;
    double percent = totalAttempts == 0
        ? 0
        : (correctAnswers / totalAttempts) * 100;

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
    for (final controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quiz = quizList[currentIndex];
    final String word = quiz['word'];
    final String meaning = quiz['meaning'];
    final List<bool> revealed = quiz['revealed'];

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('MOBIDIC'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
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
            const Center(
              child: Text(
                '빈칸채우기',
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
                '알파벳을 입력해 단어를 완성해보세요!',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(word.length, (i) {
                if (revealed[i]) {
                  return _buildLetterBox(word[i], isRevealed: true);
                } else {
                  return _buildInputBox(i);
                }
              }),
            ),
            const SizedBox(height: 30),
            Center(
              child: Text('뜻: $meaning',
                  style: const TextStyle(fontSize: 20, color: Colors.black)),
            ),
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: checkAnswer,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  backgroundColor: Colors.lightBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  '제출하기',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 80), // ✅ 하단바에 가려지지 않도록 여유 공간 추가
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

  Widget _buildLetterBox(String letter, {bool isRevealed = false}) {
    return Container(
      width: 48,
      height: 48,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isRevealed ? Colors.lightBlue[100] : Colors.white,
        border: Border.all(color: Colors.black54),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        letter,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildInputBox(int index) {
    return Container(
      width: 48,
      height: 48,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: TextField(
        controller: controllers[index],
        maxLength: 1,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 24, color: Colors.black),
        decoration: const InputDecoration(
          counterText: '',
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          if (value.length > 1) {
            controllers[index].text = value[0];
          }
          setState(() {
            userInput[index] = value;
          });
        },
      ),
    );
  }
}
