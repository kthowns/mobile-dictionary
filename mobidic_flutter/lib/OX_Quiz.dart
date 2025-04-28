import 'package:flutter/material.dart';

class OxQuizPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue.shade100, // 배경 파란색
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              'O,X Quiz',
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
                      Navigator.pop(context); // 뒤로가기
                    },
                  ),
                  Text(
                    'O,X Quiz',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'MPlusRounded1c',
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.home),
                    onPressed: () {
                      // 홈 이동 기능 나중에 추가
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 60),
            Text(
              'Apple',
              style: TextStyle(
                fontSize: 32,
                fontFamily: 'MPlusRounded1c',
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 60),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 32),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // '사과' 버튼 기능 (나중에 추가)
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  '사과',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontFamily: 'MPlusRounded1c',
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 32),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // '배' 버튼 기능 (나중에 추가)
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  '배',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontFamily: 'MPlusRounded1c',
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
