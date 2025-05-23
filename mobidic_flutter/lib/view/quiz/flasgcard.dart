
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: FlashcardScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class FlashcardScreen extends StatefulWidget {
  const FlashcardScreen({super.key});

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  int currentIndex = 0;
  bool showWord = true;
  bool showMeaning = true;

  final List<Map<String, String>> cards = [
    {'word': 'apple', 'meaning': '사과'},
    {'word': 'banana', 'meaning': '바나나'},
    {'word': 'orange', 'meaning': '오렌지'},
  ];

  void _nextCard() {
    setState(() {
      currentIndex = (currentIndex + 1) % cards.length;
      showWord = true;
      showMeaning = true;
    });
  }

  void _prevCard() {
    setState(() {
      currentIndex = (currentIndex - 1 + cards.length) % cards.length;
      showWord = true;
      showMeaning = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final card = cards[currentIndex];

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFb3e5fc), Color(0xFF81d4fa)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 상단 바
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Icon(Icons.arrow_back, size: 28),
                    Text(
                      '플래시카드',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Icon(Icons.home, size: 28),
                  ],
                ),
              ),
              // 카드 내용
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(2, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 영단어 영역
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('영단어', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            IconButton(
                              icon: Icon(showWord ? Icons.visibility : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  showWord = !showWord;
                                });
                              },
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Text(
                              card['word']!,
                              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                            ),
                            if (!showWord)
                              Positioned.fill(
                                child: Container(
                                  color: Colors.white,
                                ),
                              ),
                          ],
                        ),
                        const Divider(height: 40, thickness: 1),
                        // 뜻 영역
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('뜻', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            IconButton(
                              icon: Icon(showMeaning ? Icons.visibility : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  showMeaning = !showMeaning;
                                });
                              },
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Text(
                              card['meaning']!,
                              style: const TextStyle(fontSize: 28),
                            ),
                            if (!showMeaning)
                              Positioned.fill(
                                child: Container(
                                  color: Colors.white,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // 이전 / 다음 버튼
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      iconSize: 32,
                      onPressed: _prevCard,
                    ),
                    const SizedBox(width: 40),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      iconSize: 32,
                      onPressed: _nextCard,
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
