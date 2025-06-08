import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobidic_flutter/model/definition.dart';
import 'package:mobidic_flutter/model/word.dart';
import 'package:mobidic_flutter/type/part_of_speech.dart';
import 'package:mobidic_flutter/viewmodel/vocab_view_model.dart';
import 'package:mobidic_flutter/viewmodel/word_view_model.dart';
import 'package:provider/provider.dart';

class WordListPage extends StatelessWidget {
  WordListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vocabViewModel = context.watch<VocabViewModel>();
    final wordViewModel = context.watch<WordViewModel>();

    void showAddWordDialog() {
      List<Map<String, dynamic>> addingDefs = [
        {
          'controller': TextEditingController(),
          'partOfSpeech': PartOfSpeech.NOUN,
        },
      ];

      showDialog(
        context: context,
        builder:
            (context) => StatefulBuilder(
              builder:
                  (context, setDialogState) => AlertDialog(
                    title: const Text('단어 추가'),
                    content: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: wordViewModel.addingExpController,
                            decoration: const InputDecoration(hintText: '단어를 입력하세요'),
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
                          final String expression = wordViewModel.addingExpController.text.trim();
                          final List<Definition> meaningList = [];
                          Navigator.pop(context);
                        },
                        child: const Text('추가'),
                      ),
                    ],
                  ),
            ),
      );
    }

    void showEditWordDialog(int index) {
      TextEditingController titleController = TextEditingController(
        text: wordViewModel.words[index].expression,
      );
      TextEditingController descController = TextEditingController(
        text: wordViewModel.words[index].defs
            .map((d) => d.definition)
            .join(', '),
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
                      //wordViewModel.updateWord(wordViewModel.words[index], titleController.text.trim(), descController.text.trim(),);
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
      Word word = wordViewModel.words[index];
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
                    wordViewModel.deleteWord(word);
                    Navigator.pop(context);
                  },
                  child: const Text('예'),
                ),
              ],
            ),
      );
    }

    Color getWordBoxColor(Word word) {
      double difficulty = word.difficulty;
      difficulty = difficulty.clamp(0.0, 1.0);

      if (difficulty < 0.5) {
        // 0.0 ~ 0.5 → 파랑 → 노랑
        double t = difficulty / 0.5; // 0~1
        return Color.lerp(Colors.blue, Colors.yellow, t)!;
      } else {
        // 0.5 ~ 1.0 → 노랑 → 빨강
        double t = (difficulty - 0.5) / 0.5; // 0~1
        return Color.lerp(Colors.yellow, Colors.red, t)!;
      }
    }

    Widget buildVocabularyCard(int index) {
      final word = wordViewModel.words[index];
      final isExpanded = wordViewModel.selectedCardIndex == index;

      return Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: getWordBoxColor(word),
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
                        word.expression,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        word.defs.map((d) => "${d.definition}(${d.part.label})").join(', '),
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                if (wordViewModel.editMode)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => showEditWordDialog(index),
                        child: const Text('수정'),
                      ),
                      TextButton(
                        onPressed: () => _showDeleteDialog(index),
                        child: const Text('삭제'),
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
                //_tagButton('퀴즈', index), _tagButton('발음 체크', index)
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      );
    }

    Widget _tagButton(String label, int index) {
      return ElevatedButton(
        onPressed: () {
          if (label == '퀴즈') {
            /*
            setState(() {
              selectedCardIndex = selectedCardIndex == index ? -1 : index;
            });
             */
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

    Color getRateColor(double value) {
      value = value.clamp(0.0, 1.0);

      if (value < 0.5) {
        // 0.0 ~ 0.5 → 파랑 → 노랑
        double t = value / 0.5; // 0~1
        return Color.lerp(Colors.blue, Colors.yellow, t)!;
      } else {
        // 0.5 ~ 1.0 → 노랑 → 빨강
        double t = (value - 0.5) / 0.5; // 0~1
        return Color.lerp(Colors.yellow, Colors.red, t)!;
      }
    }

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                // 실제 뒤로 가기
                Navigator.pop(context);
              },
            ),
            title: Row(
              children: [
                SizedBox(width: 8),
                Text(
                  vocabViewModel.currentVocab?.title ?? '',
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
                  }
                },
                itemBuilder:
                    (BuildContext context) => [
                      const PopupMenuItem<String>(
                        value: '랭킹',
                        child: Text('랭킹'),
                      ),
                      const PopupMenuItem<String>(
                        value: '파닉스',
                        child: Text('파닉스'),
                      ),
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
            decoration: BoxDecoration(color: Colors.white),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 20,
                      left: 20,
                      top: 10,
                      bottom: 4,
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: '검색어를 입력하세요',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text('단어장 학습률'),
                                  SizedBox(width: 8), // 텍스트와 프로그레스 바 사이 간격
                                  Expanded(
                                    child: LinearProgressIndicator(
                                      value: wordViewModel.learningRate.clamp(
                                        0.0,
                                        1.0,
                                      ),
                                      backgroundColor: Colors.grey[300],
                                      color: getRateColor(
                                        vocabViewModel.avgLearningRate,
                                      ),
                                      minHeight: 6,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text('퀴즈 정답률'),
                                  SizedBox(width: 8), // 텍스트와 프로그레스 바 사이 간격
                                  Expanded(
                                    child: LinearProgressIndicator(
                                      value: wordViewModel.accuracy.clamp(
                                        0.0,
                                        1.0,
                                      ),
                                      backgroundColor: Colors.grey[300],
                                      color: getRateColor(
                                        wordViewModel.accuracy,
                                      ),
                                      minHeight: 6,
                                    ),
                                  ),
                                ],
                              ),
                              Text('단어 개수 : ${wordViewModel.words.length}'),
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: wordViewModel.cycleSortOption,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[100],
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
                            wordViewModel.sortOptions[wordViewModel
                                .currentSortIndex],
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: wordViewModel.toggleEditMode,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                wordViewModel.editMode
                                    ? Colors.blue[300]
                                    : Colors.blue[100],
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
                            '편집',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(padding: const EdgeInsets.symmetric(vertical: 8)),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: wordViewModel.loadData,
                      child: wordViewModel.words.isNotEmpty ? ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: wordViewModel.words.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            child: buildVocabularyCard(index),
                          );
                        },
                      ) : Center(
                        child: Text(
                          "단어를 추가해주세요.",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: showAddWordDialog,
            backgroundColor: Colors.blue[100],
            child: const Icon(Icons.add),
          ),
        ),
        if (wordViewModel.isLoading)
          Container(
            color: const Color(0x80000000), // 배경 어둡게
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}
