import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobidic_flutter/repository/rate_repository.dart';
import 'package:mobidic_flutter/repository/word_repository.dart';
import 'package:mobidic_flutter/view/list/word_list_page.dart';
import 'package:mobidic_flutter/viewmodel/vocab_view_model.dart';
import 'package:mobidic_flutter/viewmodel/word_view_model.dart';
import 'package:provider/provider.dart';

class VocabListPage extends StatelessWidget {
  VocabListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vocabViewModel = context.watch<VocabViewModel>();

    void navigateToWordList(int index) {
      vocabViewModel.currentVocab = vocabViewModel.showingVocabs[index];
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => MultiProvider(
                providers: [
                  ChangeNotifierProvider.value(value: vocabViewModel),
                  // 기존 인스턴스 전달
                  ChangeNotifierProvider(
                    create:
                        (_) => WordViewModel(
                          vocabViewModel,
                          context.read<RateRepository>(),
                          context.read<WordRepository>(),
                        ),
                  ),
                ],
                child: WordListPage(),
              ),
        ),
      );
    }

    void showAddVocabDialog() {
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

    void showEditVocabDialog(int index) {
      TextEditingController titleController = TextEditingController(
        text: vocabViewModel.showingVocabs[index].title,
      );
      TextEditingController descController = TextEditingController(
        text: vocabViewModel.showingVocabs[index].description,
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
                        vocabViewModel.showingVocabs[index],
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
                    vocabViewModel.deleteVocab(
                      vocabViewModel.showingVocabs[index],
                    );
                    Navigator.pop(context);
                  },
                  child: const Text('예'),
                ),
              ],
            ),
      );
    }

    Widget buildVocabCard(int index) {
      final progress = vocabViewModel.showingVocabs[index].learningRate;
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
                        vocabViewModel.showingVocabs[index].title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        vocabViewModel.showingVocabs[index].description,
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
                        onPressed: () => showEditVocabDialog(index),
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
                  const PopupMenuItem<String>(value: '랭킹', child: Text('랭킹')),
                  const PopupMenuItem<String>(value: '파닉스', child: Text('파닉스')),
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
                  controller: vocabViewModel.searchController,
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
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: vocabViewModel.toggleEditMode,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            vocabViewModel.editMode
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
                  onRefresh: vocabViewModel.readVocabs,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: vocabViewModel.showingVocabs.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => navigateToWordList(index),
                        child: buildVocabCard(index),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddVocabDialog,
        backgroundColor: Colors.blue[100],
        child: const Icon(Icons.add),
      ),
    );
  }
}
