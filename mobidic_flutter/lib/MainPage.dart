import 'package:flutter/material.dart';

import 'list.dart';

void main() {
  runApp(MaterialApp(
    home: VocabularyHomeScreen(),
    debugShowCheckedModeBanner: false,
    routes: {
      '/wordlist': (context) => VocabularyScreen(),
    },
  ));
}

class VocabularyHomeScreen extends StatefulWidget {
  const VocabularyHomeScreen({super.key});

  @override
  State<VocabularyHomeScreen> createState() => _VocabularyHomeScreenState();
}

class _VocabularyHomeScreenState extends State<VocabularyHomeScreen> {
  int selectedCardIndex = -1;
  List<String> vocabularyTitles = [];
  List<bool> learnedStates = [];

  void _navigateToWordList(String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WordListScreen(title: title),
      ),
    );
  }

  // ✅ 이 함수는 고정된 라우트로 이동할 때 사용
  void _navigateToWordListWithRoute() {
    Navigator.pushNamed(context, '/wordlist');
  }

  void _showAddVocabularyDialog() {
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('단어장 추가'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: '새로운 단어장을 입력해 주세요'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(() {
                  vocabularyTitles.add(controller.text.trim());
                  learnedStates.add(false);
                });
                Navigator.pop(context);
              }
            },
            child: Text('추가'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFb3e5fc), Color(0xFF81d4fa)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.arrow_back, size: 28),
                        SizedBox(width: 8),
                        Text('나만의 단어장',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Icon(Icons.home, size: 28),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: '검색어를 입력해 주세요',
                    prefixIcon: Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  onPressed: _showAddVocabularyDialog,
                  child: Text('단어장 추가'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(20),
                  itemCount: vocabularyTitles.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: _navigateToWordListWithRoute, // ✅ 배경 클릭 시 라우팅
                      child: _buildVocabularyCard(index),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVocabularyCard(int index) {
    bool isExpanded = selectedCardIndex == index;
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: learnedStates[index] ? Colors.green[100] : Colors.yellow[100],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(2, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                vocabularyTitles[index],
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Switch(
                    value: learnedStates[index],
                    onChanged: (val) {
                      setState(() {
                        learnedStates[index] = val;
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete_outline),
                    onPressed: () {},
                  )
                ],
              )
            ],
          ),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedCardIndex = isExpanded ? -1 : index;
                  });
                },
                child: Text('퀴즈'),
                style: _tagButtonStyle(),
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text('발음 체크'),
                style: _tagButtonStyle(),
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text('파닉스'),
                style: _tagButtonStyle(),
              ),
            ],
          ),
          if (isExpanded)
            Container(
              margin: const EdgeInsets.only(top: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blueAccent),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  )
                ],
              ),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  ElevatedButton(
                    onPressed: () => _navigateToWordList('플래시카드'),
                    child: Text('플래시카드'),
                  ),
                  ElevatedButton(
                    onPressed: () => _navigateToWordList('유의어 맞추기'),
                    child: Text('유의어 맞추기'),
                  ),
                  ElevatedButton(
                    onPressed: () => _navigateToWordList('받아쓰기'),
                    child: Text('받아쓰기'),
                  ),
                  ElevatedButton(
                    onPressed: () => _navigateToWordList('O/X 퀴즈'),
                    child: Text('O/X 퀴즈'),
                  ),
                  ElevatedButton(
                    onPressed: () => _navigateToWordList('빈칸 채우기'),
                    child: Text('빈칸 채우기'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  ButtonStyle _tagButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.grey[300],
      foregroundColor: Colors.black87,
      shape: StadiumBorder(),
    );
  }
}

class WordListScreen extends StatelessWidget {
  final String title;
  const WordListScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$title - 단어 목록'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Text('여기에 단어 목록이 표시됩니다.', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
