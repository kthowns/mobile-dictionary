import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobidic_flutter/view/auth/log_in_page.dart';

void main() {
  runApp(
    const MaterialApp(
      home: VocabularyHomeScreen(),
      debugShowCheckedModeBanner: false,
    ),
  );
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

  bool editMode = false;
  int selectedCardIndex = -1;

  int currentSortIndex = 0;
  final List<String> sortOptions = ['정렬', '알파벳', '학습률', '발음 학습률', '날짜'];

  void _cycleSortOption() {
    setState(() {
      currentSortIndex = (currentSortIndex + 1) % sortOptions.length;

      switch (sortOptions[currentSortIndex]) {
        case '알파벳':
          _sortBy((a, b) => a.compareTo(b));
          break;
        case '학습률':
          _sortBy(
            (a, b) => learningRates[vocabularyTitles.indexOf(b)].compareTo(
              learningRates[vocabularyTitles.indexOf(a)],
            ),
          );
          break;
        case '발음 학습률':
          _sortBy((a, b) => a.length.compareTo(b.length));
          break;
        case '날짜':
          vocabularyTitles = vocabularyTitles.reversed.toList();
          vocabularyDescriptions = vocabularyDescriptions.reversed.toList();
          learningRates = learningRates.reversed.toList();
          masterSwitches = masterSwitches.reversed.toList();
          wordDataSets = wordDataSets.reversed.toList();
          break;
      }
    });
  }

  void _navigateToWordList(String title, int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => LoginPage(
              //title: title,
              //wordList: List<Map<String, dynamic>>.from(wordDataSets[index]),
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
      builder:
          (context) => AlertDialog(
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
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('취소'),
              ),
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[100],
                  foregroundColor: Colors.black,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                ),
                child: const Text(
                  '추가',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
    );
  }

  void _showEditVocabularyDialog(int index) {
    TextEditingController titleController = TextEditingController(
      text: vocabularyTitles[index],
    );
    TextEditingController descController = TextEditingController(
      text: vocabularyDescriptions[index],
    );

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
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
                      vocabularyDescriptions[index] =
                          descController.text.trim();
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
      builder:
          (_) => AlertDialog(
            title: const Text('단어장 삭제'),
            content: const Text('이 단어장을 삭제할까요?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('아니오'),
              ),
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
              _sortBy(
                (a, b) => learningRates[vocabularyTitles.indexOf(b)].compareTo(
                  learningRates[vocabularyTitles.indexOf(a)],
                ),
              );
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
    indices.sort(
      (a, b) => comparator(vocabularyTitles[a], vocabularyTitles[b]),
    );

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
    return 0.67;
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
              if (value == '랭킹') {
                debugPrint('랭킹 메뉴 선택됨');
                // Navigator.push(...); // 랭킹 페이지로 이동 처리
              } else if (value == '파닉스') {
                debugPrint('파닉스 메뉴 선택됨');
              } else if (value == '편집') {
                setState(() {
                  editMode = !editMode; // 편집 모드 토글
                });
                // Navigator.push(...); // 파닉스 페이지로 이동 처리
              }
            },
            itemBuilder:
                (BuildContext context) => [
                  const PopupMenuItem<String>(value: '랭킹', child: Text('랭킹')),
                  const PopupMenuItem<String>(value: '파닉스', child: Text('파닉스')),
                  const PopupMenuItem<String>(value: '편집', child: Text('편집')),
                ],
          ),
          const Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.home, color: Colors.black),
          ),
        ],
      ),

      extendBodyBehindAppBar: true,
      body: Container(
        color: Colors.grey[100],
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 4,
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: '검색어를 입력하세요',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.blue[100],
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 4,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '평균 학습률 : ${_averageLearningRate().toStringAsFixed(2)}',
                          ),
                          Text(
                            '퀴즈 정답률 : ${_quizAccuracy().toStringAsFixed(2)}',
                          ),
                          Text('총 단어 개수 : ${_totalWordCount()}'),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _cycleSortOption,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[100],
                        foregroundColor: Colors.black,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                      child: Text(
                        sortOptions[currentSortIndex],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: vocabularyTitles.length + 1, // 버튼을 위한 항목 하나 추가
                  itemBuilder: (context, index) {
                    if (index < vocabularyTitles.length) {
                      return GestureDetector(
                        onTap:
                            () => _navigateToWordList(
                              vocabularyTitles[index],
                              index,
                            ),
                        child: _buildVocabularyCard(index),
                      );
                    } else {
                      // ✅ 마지막 항목에 버튼 추가
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: ElevatedButton(
                            onPressed: _showAddVocabularyDialog,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[100],
                              foregroundColor: Colors.black87,
                            ),
                            child: const Text('+단어장 추가'),
                          ),
                        ),
                      );
                    }
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
        color: Colors.blue[100],
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 2)),
        ],
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
                    Text(
                      vocabularyTitles[index],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      vocabularyDescriptions[index],
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Switch(
                    value: masterSwitches[index],
                    onChanged: (val) {
                      setState(() {
                        masterSwitches[index] = val;
                        learningRates[index] = val ? 1.0 : 0.0;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [_tagButton('퀴즈', index), _tagButton('발음 체크', index)],
          ),
          const SizedBox(height: 12),

          if (editMode)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => _showEditVocabularyDialog(index),
                  child: const Text('수정'),
                ),
                TextButton(
                  onPressed: () => _showDeleteDialog(index),
                  child: const Text('삭제'),
                ),
              ],
            ),
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
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            backgroundColor: Colors.yellow[100],
            builder: (BuildContext context) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Center(
                      child: Text(
                        '퀴즈 선택',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 2.5,
                      // 버튼 너비 비율 조정
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            //Navigator.push(context,
                            //    MaterialPageRoute(builder: (_) => const FlashcardScreen()));
                          },
                          child: const Text('플래시카드'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            //Navigator.push(context,
                            //    MaterialPageRoute(builder: (_) => const OXQuizPage()));
                          },
                          child: const Text('O/X 퀴즈'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            //Navigator.push(context,
                            //    MaterialPageRoute(builder: (_) => const DictationQuizPage()));
                          },
                          child: const Text('받아쓰기'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            //Navigator.push(context,
                            //    MaterialPageRoute(builder: (_) => const FillBlankPage()));
                          },
                          child: const Text('빈칸 채우기'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        } else if (label == '발음 체크') {
          //Navigator.push(
          //  context,
          //  //MaterialPageRoute(builder: (_) => const PronunciationScreen()),
          //);
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
