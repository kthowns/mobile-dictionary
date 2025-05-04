import 'package:flutter/material.dart';

class FillBlankPage extends StatefulWidget {
  const FillBlankPage({super.key});

  @override
  State<FillBlankPage> createState() => _FillBlankPageState();
}

class _FillBlankPageState extends State<FillBlankPage> {    //리스트
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
      answer += revealed[i] ? word[i] : (userInput[i].toLowerCase());
    }

    if (answer == word) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('정답입니다!! 🎉'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  if (currentIndex < quizList.length - 1) {
                    currentIndex++;
                    _setupCurrentQuestion();
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
          title: const Text('다시 생각해보세요. 😢'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('확인'),
            )
          ],
        ),
      );
    }
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
      appBar: AppBar(
        title: const Text('빈칸 채우기'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
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
            const SizedBox(height: 40),
            Text('뜻: $meaning', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: checkAnswer,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                backgroundColor: Colors.teal,
              ),
              child: const Text('제출하기', style: TextStyle(fontSize: 18)),
            ),
          ],
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
        color: isRevealed ? Colors.grey[300] : Colors.white,
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
        style: const TextStyle(fontSize: 24),
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
