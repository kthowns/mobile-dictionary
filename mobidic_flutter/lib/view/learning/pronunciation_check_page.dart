import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobidic_flutter/viewmodel/pronunciation_view_model.dart';
import 'package:provider/provider.dart';

class PronunciationCheckPage extends StatefulWidget {
  const PronunciationCheckPage({super.key});

  @override
  State<PronunciationCheckPage> createState() => _PronunciationCheckPageState();
}

class _PronunciationCheckPageState extends State<PronunciationCheckPage>
    with SingleTickerProviderStateMixin {
  bool _isHoldingMic = false;
  late AnimationController _controller;
  late Animation<double> _waveAnimation;

  List<double> _barHeights = List.filled(6, 20);
  Timer? _volumeTimer;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _waveAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.stop(); // 처음에는 정지
  }

  @override
  void dispose() {
    _controller.dispose();
    _volumeTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pronunciationViewModel = context.watch<PronunciationViewModel>();

    void onMicPressStart() {
      setState(() {
        _isHoldingMic = true;
      });
      _controller.repeat(reverse: true);

      pronunciationViewModel.startRecording();

      _volumeTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
        setState(() {
          _barHeights = List.generate(
            6,
            (index) => 20.0 + _random.nextDouble() * 40.0,
          );
        });
      });
    }

    void onMicPressEnd() {
      setState(() {
        _isHoldingMic = false;
        _barHeights = List.filled(6, 20);
      });
      _controller.stop();
      _volumeTimer?.cancel();

      pronunciationViewModel.stopRecordingAndUpload();

      // 점수 랜덤 생성 (60 ~ 100)
      final int score = 60 + _random.nextInt(41);

      // 커스텀 투명 다이얼로그 띄우기
      showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black54,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (context, animation, secondaryAnimation) {
          return Material(
            // ✅ Material로 감싸기
            color: Colors.transparent,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: const Text(
                  '채점 중...',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    decoration: TextDecoration.none, // ✅ 밑줄 제거 명시
                  ),
                ),
              ),
            ),
          );
        },
      );

      // 2초 후 채점 결과 다이얼로그 표시
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pop(context); // "채점 중..." 닫기

        // 점수 색상
        Color scoreColor;
        if (score < 70) {
          scoreColor = Colors.red;
        } else if (score < 85) {
          scoreColor = Colors.orange;
        } else {
          scoreColor = Colors.green;
        }

        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: const Text(
                  '발음 채점 결과',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center, // ✅ 타이틀 가운데 정렬
                ),
                content: Text.rich(
                  TextSpan(
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                    children: [
                      const TextSpan(text: '당신의 발음 점수는\n'),
                      TextSpan(
                        //text: '$score점',
                        text: pronunciationViewModel.score,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: scoreColor,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center, // ✅ 내용 가운데 정렬
                ),
                actionsAlignment: MainAxisAlignment.center,
                // ✅ 버튼 가운데 정렬 (선택사항)
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('확인', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
        );
      });
    }

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
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
                  '발음 체크',
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
                      const PopupMenuItem<String>(
                        value: '파닉스',
                        child: Text('파닉스'),
                      ),
                    ],
              ),
              Padding(
                padding: EdgeInsets.only(right: 12),
                child: IconButton(
                  icon: const Icon(Icons.home, color: Colors.black),
                  onPressed: () {
                    Navigator.popUntil(context, (route) {
                      return route.settings.name ==
                          '/vocab_list'; // 특정 route 이름 기준
                    });
                  },
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 중앙 정렬 영역 시작
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 32,
                              horizontal: 72,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFB2F2BB),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      pronunciationViewModel.words.isNotEmpty
                                          ? pronunciationViewModel
                                              .words[pronunciationViewModel
                                                  .currentWordIndex]
                                              .expression
                                          : "",
                                      style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Icon(Icons.volume_up, size: 30),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                const Text(
                                  '버튼을 눌러 발음 듣기',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),

                          // 🔄 수정된 파형 부분 시작
                          SizedBox(
                            height: 80,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(6, (i) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4.0,
                                  ),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 150),
                                    width: 8,
                                    height: _barHeights[i],
                                    decoration: BoxDecoration(
                                      color: Colors.blueAccent,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'AI 티쳐가 발음을 확인중입니다',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black54,
                            ),
                          ),
                          // 🔄 수정된 파형 부분 끝
                        ],
                      ),
                    ),
                  ),
                  // 중앙 정렬 영역 끝

                  // 하단 마이크 및 NEXT
                  GestureDetector(
                    onLongPressStart: (_) => onMicPressStart(),
                    onLongPressEnd: (_) => onMicPressEnd(),
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Color(0xFF6A7FDB), Color(0xFF52E5E7)],
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(14.0),
                        child: Icon(Icons.mic, color: Colors.white, size: 44),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '버튼을 눌러 말해보세요',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed:
                        pronunciationViewModel.words.isEmpty ||
                                pronunciationViewModel.isLoading ||
                                pronunciationViewModel.isEnd
                            ? null
                            : () {
                              if (pronunciationViewModel.currentWordIndex <
                                  pronunciationViewModel.words.length - 1) {
                                pronunciationViewModel.goToNextWord();
                              }
                            },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Colors.black12),
                    ),
                    child: const Text(
                      'NEXT',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
        if (pronunciationViewModel.isLoading)
          Container(
            color: const Color(0x80000000), // 배경 어둡게
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}
