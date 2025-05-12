import 'package:flutter/material.dart';
import 'vocab_list.dart'; // 홈으로 이동을 위한 import

void main() {
  runApp(const SynonymGameApp());
}

class SynonymGameApp extends StatelessWidget {
  const SynonymGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SynonymGameScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SynonymGameScreen extends StatefulWidget {
  const SynonymGameScreen({super.key});

  @override
  State<SynonymGameScreen> createState() => _SynonymGameScreenState();
}

class _SynonymGameScreenState extends State<SynonymGameScreen> {
  final List<Map<String, dynamic>> problems = [
    {
      'question': '눈',
      'description': '하얗고 차가운 결정체, 눈이 내리다',
      'options': ['snow', 'eye', 'class', 'ice', 'sight'],
      'answers': ['snow', 'eye'],
    },
    {
      'question': '밤',
      'description': '밤하늘, 밤에 먹는 간식 또는 열매',
      'options': ['chestnut', 'night', 'knight', 'evening', 'nut'],
      'answers': ['chestnut', 'night'],
    },
    {
      'question': '가다',
      'description': '어떤 장소로 이동하는 것',
      'options': ['go', 'walk', 'run', 'move', 'travel'],
      'answers': ['go'],
    },
    {
      'question': '빠르다',
      'description': '속도가 빠른 상태',
      'options': ['fast', 'quick', 'slow', 'rapid', 'speedy'],
      'answers': ['fast', 'quick'],
    },
    {
      'question': '좋다',
      'description': '기분이나 상태가 긍정적인 경우',
      'options': ['bad', 'nice', 'good', 'great', 'fine'],
      'answers': ['nice', 'good'],
    },
  ];

  int currentIndex = 0;
  int correctCount = 0;
  int incorrectCount = 0;
  Set<String> selected = {};
  bool showNext = false;

  void _selectOption(String option) {
    setState(() {
      if (selected.contains(option)) {
        selected.remove(option);
      } else {
        selected.add(option);
      }

      // ✅ 보기 하나라도 선택되면 버튼 활성화
      showNext = selected.isNotEmpty;
    });
  }

  bool _isCorrect() {
    final correctAnswers = problems[currentIndex]['answers'] as List<String>;
    return selected.length == correctAnswers.length &&
        selected.every((s) => correctAnswers.contains(s));
  }

  void _goToNext() {
    final isAnswerCorrect = _isCorrect();

    setState(() {
      if (isAnswerCorrect) {
        correctCount++;
      } else {
        incorrectCount++;
      }

      if (currentIndex < problems.length - 1) {
        currentIndex++;
        selected.clear();
        showNext = false;
      } else {
        _showSummaryDialog();
      }
    });
  }

  void _showSummaryDialog() {
    final total = problems.length;
    final accuracy = (correctCount / total * 100).toStringAsFixed(1);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('퀴즈 완료'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('총 문제 수: $total'),
            Text('맞힌 문제 수: $correctCount'),
            Text('틀린 문제 수: $incorrectCount'),
            Text('정확도: $accuracy%'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _resetQuiz();
            },
            child: const Text('처음부터'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('닫기'),
          ),
        ],
      ),
    );
  }

  void _resetQuiz() {
    setState(() {
      currentIndex = 0;
      correctCount = 0;
      incorrectCount = 0;
      selected.clear();
      showNext = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final problem = problems[currentIndex];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFb3e5fc),
        title: const Text('유의어 맞추기', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home, color: Colors.black),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const VocabularyHomeScreen()),
                    (route) => false,
              );
            },
          ),
        ],
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFb3e5fc), Color(0xFF81d4fa)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // 상단 진행 정보
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('맞힘: $correctCount',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text('진행: ${currentIndex + 1}/${problems.length}',
                        style: const TextStyle(fontSize: 16)),
                    Text('틀림: $incorrectCount',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),

              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(height: 20),

                    // 문제 설명 박스
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF9C4),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '제시어: ${problem['question']}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            problem['description'],
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    // 보기 리스트
                    ...List.generate(problem['options'].length, (index) {
                      String option = problem['options'][index];
                      bool isSelected = selected.contains(option);
                      bool isCorrect = problem['answers'].contains(option);

                      Color bgColor;
                      if (isSelected) {
                        bgColor = isCorrect ? Colors.green : Colors.redAccent;
                      } else {
                        bgColor = Colors.white;
                      }

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: ListTile(
                          title: Text(
                            option,
                            style: const TextStyle(fontSize: 18),
                          ),
                          onTap: () => _selectOption(option),
                        ),
                      );
                    }),

                    const SizedBox(height: 20),

                    if (showNext)
                      Center(
                        child: ElevatedButton(
                          onPressed: _goToNext,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(currentIndex < problems.length - 1 ? '다음 문제' : '퀴즈 완료'),
                        ),
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
