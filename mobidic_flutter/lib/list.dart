import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: VocabularyScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class VocabularyScreen extends StatefulWidget {
  const VocabularyScreen({Key? key}) : super(key: key);

  @override
  State<VocabularyScreen> createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends State<VocabularyScreen> {
  List<Map<String, dynamic>> wordList = [];

  void _showAddWordDialog() {
    TextEditingController wordController = TextEditingController();
    TextEditingController meaningController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('단어 추가'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: wordController,
                decoration: InputDecoration(hintText: '단어를 입력하세요'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: meaningController,
                decoration: InputDecoration(hintText: '뜻을 입력하세요'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('취소'),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: Text('추가'),
              onPressed: () {
                if (wordController.text.isNotEmpty &&
                    meaningController.text.isNotEmpty) {
                  setState(() {
                    wordList.add({
                      'word': wordController.text,
                      'meaning': meaningController.text,
                      'isLearned': false,
                    });
                  });
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('단어 삭제'),
        content: Text('단어를 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('아니오'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                wordList.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: Text('예'),
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
                        IconButton(
                          icon: const Icon(Icons.arrow_back, size: 28),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        const Text(
                          '단어장 1',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.home, size: 28),
                      onPressed: () {
                        // 홈 이동 처리
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: '검색어를 입력해 주세요',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton.icon(
                  onPressed: _showAddWordDialog,
                  icon: Icon(Icons.add),
                  label: Text('단어 추가'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: wordList.length,
                  itemBuilder: (context, index) {
                    final word = wordList[index];
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: word['isLearned'] ? Colors.green[200] : Colors.yellow[200],
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  word['word'],
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Switch(
                                    value: word['isLearned'],
                                    onChanged: (val) {
                                      setState(() {
                                        word['isLearned'] = val;
                                      });
                                    },
                                  ),
                                  Column(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.volume_up),
                                        onPressed: () {
                                          // 발음 재생 처리 가능
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete_outline),
                                        onPressed: () => _showDeleteDialog(index),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            word['meaning'],
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
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
}
