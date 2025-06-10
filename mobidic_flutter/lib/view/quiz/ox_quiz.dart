import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
      builder:
          (_) => AlertDialog(
            title: Text(isCorrect ? "정답입니다!! 🎉" : "오답입니다. 😢"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (currentIndex < quizList.length - 1) {
                    setState(() {
                      currentIndex++;
                    });
                  } else {
                    _showCompletionDialog();
                  }
                },
                child: const Text("다음 문제"),
              ),
            ],
          ),
    );
  }

  void _showCompletionDialog() {
    int wrongAnswers = totalAttempts - correctAnswers;
    double percent =
        totalAttempts == 0 ? 0 : (correctAnswers / totalAttempts) * 100;

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
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
  Widget build(BuildContext context) {
    final currentQuiz = quizList[currentIndex];
    final int quizColor = 0xFFb3e5fc;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(quizColor),
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // 원하는 로직
            print('뒤로가기 누름');
            // 실제 뒤로 가기
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            Center(
              child: Image.asset('assets/images/mobidic_icon.png', height: 40),
            ),
            SizedBox(width: 8),
            Text(
              'MOBIDIC',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.menu, color: Colors.black),
            onSelected: (value) {
              if (value == '파닉스') {
                Navigator.pushNamed(context, '/phonics');
              }
            },
            itemBuilder:
                (BuildContext context) => [
              const PopupMenuItem<String>(
                value: '파닉스',
                child: Text('파닉스'),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: IconButton(
              icon: const Icon(Icons.home, color: Colors.black),
              onPressed: () {
                Navigator.popUntil(context, (route) {
                  return route.settings.name ==
                      '/vocab_list'; // 특정 route 이름 기준
                });
              },
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFFb3e5fc),
        ),

        child: SafeArea(
          child: Column(
            children: [
              // 카드 내용
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(2, 4),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // 카드 내용
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // 영단어 영역
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('영단어',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Text(
                                  quizList[0]['word']!,
                                  style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const Divider(height: 50, thickness: 1),

                            // 뜻 영역
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('뜻',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Text(
                                  quizList[0]['meaning']!,
                                  style: const TextStyle(fontSize: 28),
                                ),
                              ],
                            ),
                          ],
                        ),

                        // 진행률 우측 상단
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Text(
                            '${currentIndex + 1}/${quizList.length}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // 이전 / 다음 버튼
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0, top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      iconSize: 32,
                      onPressed: (){},
                    ),
                    const SizedBox(width: 40),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      iconSize: 32,
                      onPressed: (){},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//OX퀴즈 오류 수정
