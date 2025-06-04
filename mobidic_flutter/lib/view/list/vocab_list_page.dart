import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobidic_flutter/viewmodel/vocab_view_model.dart';
import 'package:provider/provider.dart';

class VocabListPage extends StatelessWidget {
  VocabListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vocabViewModel = context.watch<VocabViewModel>();

    void navigateToWordList(int index) {
      vocabViewModel.selectedCardIndex = index;
      //Navigator.pushNamed(context, 'word_list');
    }

    void showAddVocabularyDialog() {
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
                    decoration: const InputDecoration(
                      hintText: '세부 설명을 입력해주세요',
                    ),
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
                      vocabViewModel.addVocab(
                        titleController.text,
                        descController.text,
                      );
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
      TextEditingController titleController = TextEditingController(
        text: vocabViewModel.vocabs[index].title,
      );
      TextEditingController descController = TextEditingController(
        text: vocabViewModel.vocabs[index].description,
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
                      vocabViewModel.updateVocab(
                        vocabViewModel.vocabs[index].id,
                        titleController.text.trim(),
                        descController.text.trim(),
                      );
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
                    vocabViewModel.deleteVocab(vocabViewModel.vocabs[index].id);
                    Navigator.pop(context);
                  },
                  child: const Text('예'),
                ),
              ],
            ),
      );
    }

    Widget buildVocabularyCard(int index) {
      final progress = vocabViewModel.vocabs[index].learningRate;
      final isExpanded = vocabViewModel.selectedCardIndex == index;

      return Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: Colors.blue[100],
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
                        vocabViewModel.vocabs[index].title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        vocabViewModel.vocabs[index].description,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                if (vocabViewModel.editMode)
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // 원하는 로직
            print('뒤로가기 누름');

            // 실제 뒤로 가기
            Navigator.pop(context);
          },
        ),
        title: const Row(
          children: [
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '평균 학습률 : ${vocabViewModel.getAvgLearningRate().toStringAsFixed(2)}',
                          ),
                          Text(
                            '퀴즈 정답률 : ${vocabViewModel.accuracy.toStringAsFixed(2)}',
                          ),
                          Text('단어장 개수 : ${vocabViewModel.vocabs.length}'),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: vocabViewModel.cycleSortOption,
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
                        vocabViewModel.sortOptions[vocabViewModel
                            .currentSortIndex],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: showAddVocabularyDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[100],
                        foregroundColor: Colors.black87,
                      ),
                      child: const Text('단어장 추가'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: vocabViewModel.vocabs.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => navigateToWordList(index),
                      child: buildVocabularyCard(index),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final RenderBox overlay =
              Overlay.of(context).context.findRenderObject() as RenderBox;

          final selected = await showMenu<String>(
            context: context,
            position: RelativeRect.fromLTRB(
              overlay.size.width,
              overlay.size.height - 100,
              0,
              0,
            ),
            items: [
              const PopupMenuItem<String>(value: '랭킹', child: Text('랭킹')),
              const PopupMenuItem<String>(value: '파닉스', child: Text('파닉스')),
              const PopupMenuItem<String>(value: '편집', child: Text('편집')),
            ],
          );

          if (selected != null) {
            if (selected == '랭킹') {
              debugPrint('랭킹 메뉴 선택됨');
              // Navigator.push(...);
            } else if (selected == '파닉스') {
              debugPrint('파닉스 메뉴 선택됨');
            } else if (selected == '편집') {
              vocabViewModel.toggleEditMode();
            }
          }
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue[100],
      ),
    );
  }
}
