import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobidic_flutter/viewmodel/blank_quiz_view_model.dart';
import 'package:provider/provider.dart';

class FillBlankQuizPage extends StatelessWidget {
  const FillBlankQuizPage({super.key});

  @override
  Widget build(BuildContext context) {
    final int quizColor = 0xFFb3e5fc;
    final BlankQuizViewModel blankQuizViewModel =
        context.watch<BlankQuizViewModel>();

    Widget buildFirstHalf() {
      return Column(
        children: [
          Expanded(child: Container()),
          Column(
            children: [
              Text(
                blankQuizViewModel.questions.isNotEmpty
                    ? blankQuizViewModel.currentQuestion.stem
                    : "-",
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 5,
                ),
              ),
              const Divider(height: 30, thickness: 1),
              Text(
                blankQuizViewModel.questions.isNotEmpty
                    ? blankQuizViewModel.currentQuestion.options.join(', ')
                    : "-",
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              if (blankQuizViewModel.isSolved)
                Text(
                  blankQuizViewModel.resultMessage,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              if (blankQuizViewModel.isDone)
                Column(
                  children: [
                    Text(
                      "정답률 : ${blankQuizViewModel.correctCount}/"
                      "${blankQuizViewModel.correctCount + blankQuizViewModel.incorrectCount}",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 40),
            ],
          ),
        ],
      );
    }

    Widget buildSecondHalf() {
      return Column(
        children: [
          SizedBox(height: 20),
          Text(
            "전체 단어를 입력해주세요",
            style: const TextStyle(fontSize: 24, color: Colors.black),
          ),
          SizedBox(height: 20),
          TextField(
            enabled: blankQuizViewModel.isButtonAvailable,
            controller: blankQuizViewModel.userAnswerController,
            maxLines: 1,
            maxLength: blankQuizViewModel.questions.isNotEmpty ?
              blankQuizViewModel.currentQuestion.stem.length : 10,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 30, color: Colors.black),
            decoration: const InputDecoration(
              counterText: '',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (s) {
              blankQuizViewModel.checkAnswer(s);
            },
          ),
          SizedBox(height: 30,),
          SizedBox(
            width: double.infinity, // 부모 너비를 가득 채움
            child: ElevatedButton(
              onPressed: blankQuizViewModel.isButtonAvailable ?
                  (){
                blankQuizViewModel.checkAnswer(blankQuizViewModel.currentAnswer);
              } : null,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                backgroundColor: Colors.blue[100],
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text("제출하기",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.blueAccent
                ),
              ),
            ),
          )
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(quizColor),
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            Center(
              child: Image.asset('assets/images/mobidic_icon.png', height: 40),
            ),
            SizedBox(width: 8),
            Text(
              'MOBIDIC',
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
              if (value == '파닉스') {
                Navigator.pushNamed(context, '/phonics');
              }
            },
            itemBuilder:
                (BuildContext context) => [
                  const PopupMenuItem<String>(value: '파닉스', child: Text('파닉스')),
                ],
          ),
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: IconButton(
              icon: const Icon(Icons.home, color: Colors.black),
              onPressed: () {
                Navigator.popUntil(context, (route) {
                  return route.settings.name == '/vocab_list'; // 특정 route 이름 기준
                });
              },
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(color: Color(0xFFb3e5fc)),
            child: SafeArea(
              child: Column(
                children: [
                  // 카드 내용
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 6,
                              offset: Offset(2, 4),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            // 카드 내용
                            Column(
                              children: [
                                Expanded(child: buildFirstHalf()),
                                Expanded(child: buildSecondHalf()),
                              ],
                            ),
                            // 진행률 우측 상단
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Text(
                                '${blankQuizViewModel.currentQuestionIndex + 1}/'
                                '${blankQuizViewModel.questions.length}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              left: 0,
                              child: Text(
                                '남은 시간: ${blankQuizViewModel.secondsLeft}\'s',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (blankQuizViewModel.isLoading)
            Container(
              color: const Color(0x80000000), // 배경 어둡게
              child: const Center(child: CircularProgressIndicator()),
            ),
          if (blankQuizViewModel.questions.isEmpty &&
              !blankQuizViewModel.isLoading)
            Container(
              color: const Color(0x80000000), // 배경 어둡게
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.help_outline, size: 64, color: Colors.white70),
                    SizedBox(height: 16),
                    Text(
                      '단어장이 비어있습니다.',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '단어장에 단어를 추가해보세요!',
                      style: TextStyle(color: Colors.white54, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
