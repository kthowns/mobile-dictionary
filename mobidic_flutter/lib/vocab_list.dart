import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'word_list.dart';
import 'quiz_flash.dart';
import 'quiz_synon.dart';
import 'OX_Quiz.dart';
import 'Fill_blank.dart';
import 'Dictation.dart';

void main() {
  runApp(const MaterialApp(
    home: VocabularyHomeScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class VocabularyHomeScreen extends StatefulWidget {
  const VocabularyHomeScreen({super.key});

  @override
  State<VocabularyHomeScreen> createState() => _VocabularyHomeScreenState();
}

class _VocabularyHomeScreenState extends State<VocabularyHomeScreen> {
  List<String> vocabularyTitles = [];
  List<String> vocabularyDescriptions = [];
  List<double> learningRates = [];
  List<bool> masterSwitches = [];
  List<List<Map<String, dynamic>>> wordDataSets = [];
  int selectedCardIndex = -1;

  void _navigateToWordList(String title, int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WordListScreen(
          title: title,
          wordList: List<Map<String, dynamic>>.from(wordDataSets[index]),
        ),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        learningRates[index] = result['progress'];
        masterSwitches[index] = result['progress'] == 1.0;
        wordDataSets[index] = result['words'];
      });
    }
  }

  void _showAddVocabularyDialog() {
    TextEditingController titleController = TextEditingController();
    TextEditingController descController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('단어장 추가'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(hintText: '새 단어장 이름'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descController,
              decoration: const InputDecoration(hintText: '세부 설명을 입력해주세요'),
              style: const TextStyle(fontSize: 13),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('취소')),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.trim().isNotEmpty) {
                setState(() {
                  vocabularyTitles.add(titleController.text.trim());
                  vocabularyDescriptions.add(descController.text.trim());
                  learningRates.add(0.0);
                  masterSwitches.add(false);
                  wordDataSets.add([]);
                });
                Navigator.pop(context);
              }
            },
            child: const Text('추가'),
          ),
        ],
      ),
    );
  }

  void _showEditVocabularyDialog(int index) {
    TextEditingController titleController =
    TextEditingController(text: vocabularyTitles[index]);
    TextEditingController descController =
    TextEditingController(text: vocabularyDescriptions[index]);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('단어장 편집'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(hintText: '단어장 이름'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descController,
              decoration: const InputDecoration(hintText: '세부 설명'),
              style: const TextStyle(fontSize: 13),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.trim().isNotEmpty) {
                setState(() {
                  vocabularyTitles[index] = titleController.text.trim();
                  vocabularyDescriptions[index] = descController.text.trim();
                });
                Navigator.pop(context);
              }
            },
            child: const Text('저장'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('단어장 삭제'),
        content: const Text('이 단어장을 삭제할까요?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('아니오')),
          TextButton(
            onPressed: () {
              setState(() {
                vocabularyTitles.removeAt(index);
                vocabularyDescriptions.removeAt(index);
                learningRates.removeAt(index);
                masterSwitches.removeAt(index);
                wordDataSets.removeAt(index);
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
        PopupMenuItem(
          child: const Text('알파벳'),
          onTap: () {
            setState(() {
              _sortBy((a, b) => a.compareTo(b));
            });
          },
        ),
        PopupMenuItem(
          child: const Text('학습률'),
          onTap: () {
            setState(() {
              _sortBy((a, b) => learningRates[vocabularyTitles.indexOf(b)].compareTo(
                learningRates[vocabularyTitles.indexOf(a)],
              ));
            });
          },
        ),
        PopupMenuItem(
          child: const Text('발음 체크'),
          onTap: () {
            setState(() {
              _sortBy((a, b) => a.length.compareTo(b.length));
            });
          },
        ),
      ],
    );
  }

  void _sortBy(Comparator<String> comparator) {
    List<int> indices = List.generate(vocabularyTitles.length, (i) => i);
    indices.sort((a, b) => comparator(vocabularyTitles[a], vocabularyTitles[b]));

    vocabularyTitles = [for (var i in indices) vocabularyTitles[i]];
    vocabularyDescriptions = [for (var i in indices) vocabularyDescriptions[i]];
    learningRates = [for (var i in indices) learningRates[i]];
    masterSwitches = [for (var i in indices) masterSwitches[i]];
    wordDataSets = [for (var i in indices) wordDataSets[i]];
  }

  double _averageLearningRate() {
    if (learningRates.isEmpty) return 0.0;
    return learningRates.reduce((a, b) => a + b) / learningRates.length;
  }

  double _quizAccuracy() {
    return 0.67; // 실제 정답률 데이터로 대체 가능
  }

  int _totalWordCount() {
    return wordDataSets.fold(0, (sum, list) => sum + list.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title: const Row(
          children: [
            Icon(Icons.arrow_back, size: 24, color: Colors.black),
            SizedBox(width: 8),
            Text(
              '나만의 단어장',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: _showSortMenu,
          ),
          const Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.home, color: Colors.black),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('평균 학습률 : ${_averageLearningRate().toStringAsFixed(2)}'),
                        Text('퀴즈 정답률 : ${_quizAccuracy().toStringAsFixed(2)}'),
                        Text('총 단어 개수 : ${_totalWordCount()}'),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: '검색어를 입력하세요',
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
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _showAddVocabularyDialog,
                      child: const Text('단어장 추가'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: vocabularyTitles.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => _navigateToWordList(vocabularyTitles[index], index),
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
    final progress = learningRates[index];
    final isExpanded = selectedCardIndex == index;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.yellow[100],
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(vocabularyTitles[index],
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(
                      vocabularyDescriptions[index],
                      style: const TextStyle(fontSize: 13, color: Colors.black54),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.black),
                    onPressed: () => _showEditVocabularyDialog(index),
                  ),
                  Switch(
                    value: masterSwitches[index],
                    onChanged: (val) {
                      setState(() {
                        masterSwitches[index] = val;
                        learningRates[index] = val ? 1.0 : 0.0;
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.black),
                    onPressed: () => _showDeleteDialog(index),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              _tagButton('퀴즈', index),
              _tagButton('발음 체크', index),
              _tagButton('파닉스', index),
            ],
          ),
          const SizedBox(height: 12),
          if (isExpanded)
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blueAccent),
              ),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const FlashcardScreen())),
                    child: const Text('플래시카드'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const OXQuizPage())),
                    child: const Text('O/X 퀴즈'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const DictationQuizPage())),
                    child: const Text('받아쓰기'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const FillBlankPage())),
                    child: const Text('빈칸 채우기'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const SynonymGameScreen())),
                    child: const Text('유의어 맞추기'),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    Container(height: 20, color: Colors.grey[300]),
                    Container(
                      height: 20,
                      width: constraints.maxWidth * progress,
                      decoration: const BoxDecoration(color: Colors.green),
                    ),
                    Positioned.fill(
                      child: Center(
                        child: Text(
                          '${(progress * 100).toInt()}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _tagButton(String label, int index) {
    return ElevatedButton(
      onPressed: () {
        if (label == '퀴즈') {
          setState(() {
            selectedCardIndex = selectedCardIndex == index ? -1 : index;
          });
        }
      },
      child: Text(label),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        textStyle: const TextStyle(fontSize: 12),
        backgroundColor: Colors.grey[300],
        foregroundColor: Colors.black87,
        shape: const StadiumBorder(),
      ),
    );
  }
}
