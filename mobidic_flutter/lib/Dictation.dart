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
      backgroundColor: Colors.lightBlue.shade100,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              '받아쓰기',
              style: TextStyle(
                fontSize: 28,
                fontFamily: 'Baloo2',
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    '받아쓰기 - eazy',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'MPlusRounded1c',
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.home),
                    onPressed: () {
                      // 홈으로 이동하는 기능은 나중에 추가
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 32),
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Icon(Icons.volume_up, size: 40),
                  SizedBox(height: 10),
                  Text(
                    '들리는 단어를 써보세요',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'MPlusRounded1c',
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 40,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(''), // 입력 기능은 아직 없음
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Text(
              '오답률 : 20%',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'MPlusRounded1c',
              ),
            ),
            SizedBox(height: 10),
            Switch(
              value: false,
              onChanged: (value) {},
            ),
            SizedBox(height: 5),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '뜻 / 영단어 변경',
                style: TextStyle(
                  fontFamily: 'MPlusRounded1c',
                  fontSize: 14,
                ),
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NextPage()), // NEXT 버튼 누르면 이동!
                );
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Text(
                    'NEXT',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Baloo2',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// NEXT 버튼 누르면 이동할 "임시 페이지" 만들기
class NextPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('다음 화면'),
      ),
      body: Center(
        child: Text(
          '여기는 다음 화면입니다!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
