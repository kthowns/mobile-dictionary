import 'package:flutter/material.dart';

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
      'options': ['snow', 'eye', 'class'],
      'answers': ['snow', 'eye'],
    },
    {
      'question': '밤',
      'description': '밤하늘, 밤에 먹는 간식 또는 열매',
      'options': ['chestnut', 'night', 'knight'],
      'answers': ['chestnut', 'night'],
    },
  ];

  int currentIndex = 0;
  Set<String> selected = {};
  bool showNext = false;

  void _selectOption(String option) {
    setState(() {
      if (selected.contains(option)) {
        selected.remove(option);
      } else {
        selected.add(option);
      }

      if (_isCorrect()) {
        showNext = true;
      } else {
        showNext = false;
      }
    });
  }

  bool _isCorrect() {
    final correctAnswers = problems[currentIndex]['answers'] as List<String>;
    return selected.length == correctAnswers.length &&
        selected.every((s) => correctAnswers.contains(s));
  }

  void _goToNext() {
    setState(() {
      currentIndex = (currentIndex + 1) % problems.length;
      selected.clear();
      showNext = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final problem = problems[currentIndex];

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(24.0),
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFb3e5fc), Color(0xFF81d4fa)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.arrow_back, size: 28),
                    SizedBox(width: 8),
                    Text('유의어 맞추기',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
                const Icon(Icons.home, size: 28),
              ],
            ),
            const SizedBox(height: 30),

            // 중앙 제시어 박스
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 20, horizontal: 40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Text(
                  '제시어: ${problem['question']}',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 설명 중앙 정렬
            Center(
              child: Text(
                problem['description'],
                style: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 30),

            // 보기 버튼 중앙 정렬
            Center(
              child: Column(
                children: List.generate(
                    (problem['options'] as List).length, (index) {
                  String option = problem['options'][index];
                  bool isSelected = selected.contains(option);
                  Color bgColor = isSelected
                      ? (problem['answers'].contains(option)
                      ? Colors.green
                      : Colors.grey)
                      : Colors.grey.shade400;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ElevatedButton(
                      onPressed: () => _selectOption(option),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: bgColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 30),
                        shape: const StadiumBorder(),
                      ),
                      child: Text(option,
                          style: const TextStyle(fontSize: 18)),
                    ),
                  );
                }),
              ),
            ),

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
                  child: const Text('다음 문제'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
