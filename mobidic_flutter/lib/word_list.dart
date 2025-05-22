import 'package:flutter/material.dart';
import 'vocab_list.dart';

enum PartOfSpeech {
  NOUN('명사'),
  PRONOUN('대명사'),
  VERB('동사'),
  ADJECTIVE('형용사'),
  ADVERB('부사'),
  ARTICLE('관사'),
  PREPOSITION('전치사'),
  CONJUNCTION('접속사'),
  INTERJECTION('감탄사');

  final String label;
  const PartOfSpeech(this.label);
}

class WordListScreen extends StatefulWidget {
  final String title;
  final List<Map<String, dynamic>> wordList;

  const WordListScreen({
    required this.title,
    required this.wordList,
    super.key,
  });

  @override
  State<WordListScreen> createState() => _WordListScreenState();
}

class _WordListScreenState extends State<WordListScreen> {
  late List<Map<String, dynamic>> wordList;

  @override
  void initState() {
    super.initState();
    wordList = List<Map<String, dynamic>>.from(widget.wordList);
  }

  void _showEditDialog(int index) {
    final word = wordList[index];
    TextEditingController wordController = TextEditingController(text: word['word']);

    List<Map<String, dynamic>> meanings = (word['meaning'] as String)
        .split(', ')
        .map((entry) {
      final match = RegExp(r'(.+?)\((.+)\)').firstMatch(entry);
      return {
        'controller': TextEditingController(text: match?.group(1) ?? entry),
        'partOfSpeech': PartOfSpeech.values.firstWhere(
              (pos) => pos.label == match?.group(2),
          orElse: () => PartOfSpeech.NOUN,
        ),
      };
    }).toList();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          final List<Widget> meaningFields = [];
          for (var i = 0; i < meanings.length; i++) {
            final item = meanings[i];
            meaningFields.add(
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: item['controller'],
                        decoration: const InputDecoration(hintText: '뜻을 입력하세요'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    DropdownButton<PartOfSpeech>(
                      value: item['partOfSpeech'],
                      items: PartOfSpeech.values.map((pos) {
                        return DropdownMenuItem(
                          value: pos,
                          child: Text(pos.label),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setDialogState(() {
                          item['partOfSpeech'] = newValue!;
                        });
                      },
                    ),
                    if (meanings.length > 1)
                      IconButton(
                        icon: const Icon(Icons.remove_circle, color: Colors.red),
                        onPressed: () {
                          setDialogState(() {
                            meanings.removeAt(i);
                          });
                        },
                      ),
                  ],
                ),
              ),
            );
          }

          return AlertDialog(
            title: const Text('단어 편집'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: wordController,
                    decoration: const InputDecoration(hintText: '단어를 입력하세요'),
                  ),
                  const SizedBox(height: 10),
                  ...meaningFields,
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () {
                        setDialogState(() {
                          meanings.add({
                            'controller': TextEditingController(),
                            'partOfSpeech': PartOfSpeech.NOUN,
                          });
                        });
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('뜻 추가'),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('취소'),
              ),
              ElevatedButton(
                onPressed: () {
                  final updatedWord = wordController.text.trim();
                  final updatedMeanings = meanings
                      .where((m) => m['controller'].text.trim().isNotEmpty)
                      .map((m) =>
                  '${m['controller'].text.trim()}(${(m['partOfSpeech'] as PartOfSpeech).label})')
                      .toList();

                  if (updatedWord.isNotEmpty && updatedMeanings.isNotEmpty) {
                    setState(() {
                      wordList[index]['word'] = updatedWord;
                      wordList[index]['meaning'] = updatedMeanings.join(', ');
                    });
                    Navigator.pop(context);
                  }
                },
                child: const Text('저장'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showAddWordDialog() {
    TextEditingController wordController = TextEditingController();
    List<Map<String, dynamic>> meanings = [
      {'controller': TextEditingController(), 'partOfSpeech': PartOfSpeech.NOUN}
    ];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('단어 추가'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: wordController,
                  decoration: const InputDecoration(hintText: '단어를 입력하세요'),
                ),
                const SizedBox(height: 10),
                ...meanings.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: item['controller'],
                            decoration: const InputDecoration(hintText: '뜻을 입력하세요'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        DropdownButton<PartOfSpeech>(
                          value: item['partOfSpeech'],
                          items: PartOfSpeech.values.map((pos) {
                            return DropdownMenuItem(
                              value: pos,
                              child: Text(pos.label),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setDialogState(() {
                              item['partOfSpeech'] = newValue!;
                            });
                          },
                        ),
                        if (meanings.length > 1)
                          IconButton(
                            icon: const Icon(Icons.remove_circle, color: Colors.red),
                            onPressed: () {
                              setDialogState(() {
                                meanings.removeAt(index);
                              });
                            },
                          ),
                      ],
                    ),
                  );
                }).toList(),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () {
                      final hasText = meanings.any((m) => m['controller'].text.trim().isNotEmpty);
                      if (!hasText) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('뜻을 먼저 입력해 주세요')),
                        );
                      } else {
                        setDialogState(() {
                          meanings.add({
                            'controller': TextEditingController(),
                            'partOfSpeech': PartOfSpeech.NOUN,
                          });
                        });
                      }
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('뜻 추가'),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소'),
            ),
            ElevatedButton(
              onPressed: () {
                final word = wordController.text.trim();
                final meaningList = meanings
                    .where((m) => m['controller'].text.trim().isNotEmpty)
                    .map((m) =>
                '${m['controller'].text.trim()}(${(m['partOfSpeech'] as PartOfSpeech).label})')
                    .toList();

                if (word.isNotEmpty && meaningList.isNotEmpty) {
                  setState(() {
                    wordList.add({
                      'word': word,
                      'meaning': meaningList.join(', '),
                      'isLearned': false,
                    });
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('추가'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('단어 삭제'),
        content: const Text('단어를 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('아니오'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                wordList.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: const Text('예'),
          ),
        ],
      ),
    );
  }

  void _showSortMenu() {
    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(1000, 80, 10, 0),
      items: [
        const PopupMenuItem(child: Text('알파벳')),
        const PopupMenuItem(child: Text('학습별')),
        const PopupMenuItem(child: Text('발음 완성도')),
        const PopupMenuItem(child: Text('날짜 순')),
      ],
    );
  }

  void _returnDataAndGoBack() {
    final learnedCount = wordList.where((word) => word['isLearned'] == true).length;
    final progress = wordList.isEmpty ? 0.0 : learnedCount / wordList.length;
    Navigator.pop(context, {
      'progress': progress,
      'words': wordList,
    });
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
                    IconButton(
                      icon: const Icon(Icons.arrow_back, size: 28),
                      onPressed: _returnDataAndGoBack,
                    ),
                    Text(
                      widget.title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.menu),
                          onPressed: _showSortMenu,
                        ),
                        IconButton(
                          icon: const Icon(Icons.home, size: 28),
                          onPressed: () {
                            Navigator.popUntil(context, (route) => route.isFirst);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: '단어 검색',
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
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: ElevatedButton.icon(
                  onPressed: _showAddWordDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('단어 추가'),
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
              Expanded(
                child: ListView.builder(
                  itemCount: wordList.length,
                  itemBuilder: (context, index) {
                    final word = wordList[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: word['isLearned'] ? Colors.green[200] : Colors.yellow[200],
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
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
                                child: Row(
                                  children: [
                                    Text(
                                      word['word'],
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    TextButton(
                                      onPressed: () {
                                        // TODO: 발음 체크 기능
                                      },
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.grey[300],
                                        foregroundColor: Colors.black87,
                                        shape: const StadiumBorder(),
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                      ),
                                      child: const Text(
                                        '발음 체크',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () => _showEditDialog(index),
                                  ),
                                  Switch(
                                    value: word['isLearned'],
                                    onChanged: (val) {
                                      setState(() {
                                        word['isLearned'] = val;
                                      });
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline),
                                    onPressed: () => _showDeleteDialog(index),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            word['meaning'],
                            style: const TextStyle(fontSize: 16),
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
