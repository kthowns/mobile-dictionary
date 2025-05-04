import 'package:flutter/material.dart';

class Fill_blank extends StatefulWidget {
  @override
  _Fill_blankState createState() => _Fill_blankState();
}

class _Fill_blankState extends State<Fill_blank> {
  final TextEditingController answerController = TextEditingController();
  String resultText = '';

  void checkAnswer() {
    String userAnswer = answerController.text.trim().toLowerCase();
    if (userAnswer == 'apple') {
      setState(() {
        resultText = 'Correct!!';
      });
    } else {
      setState(() {
        resultText = 'Try again..';
      });
    }
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
                    '빈칸 채우기',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'MPlusRounded1c',
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.home),
                    onPressed: () {
                      // 홈 이동 기능 추가 예정
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 60),
            Text(
              '사과',
              style: TextStyle(
                fontSize: 32,
                fontFamily: 'MPlusRounded1c',
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 40),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 32),
              child: TextField(
                controller: answerController,
                decoration: InputDecoration(
                  hintText: '정답 입력',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: checkAnswer,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
              ),
              child: Text(
                '확인',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontFamily: 'MPlusRounded1c',
                ),
              ),
            ),
            SizedBox(height: 30),
            Text(
              resultText,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'MPlusRounded1c',
                color: resultText == 'Correct!!' ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
