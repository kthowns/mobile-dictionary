import 'package:flutter/material.dart';
import 'dart:async';
import 'Log_in_page.dart';

class FindPwPage extends StatefulWidget {
  const FindPwPage({super.key});

  @override
  State<FindPwPage> createState() => _FindPwPageState();
}

class _FindPwPageState extends State<FindPwPage> {
  final emailController = TextEditingController();
  int attemptCount = 0;
  bool isLocked = false;
  String errorMessage = "";
  int remainingSeconds = 0;
  Timer? countdownTimer;

  void tryFindPw() {
    if (isLocked) return;

    String email = emailController.text.trim();

    setState(() {
      attemptCount++;
    });

    if (attemptCount > 5) {
      startLockTimer();
      setState(() {
        isLocked = true;
        errorMessage = "시도 횟수 5회를 초과했습니다. 3분 후, 다시 시도해주세요.";
      });
      return;
    }

    if (email == "junseok@test.com") {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("비밀번호 찾기"),
          content: const Text("당신의 비밀번호는: pw1234"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => LoginPage()),
                );
              },
              child: const Text("로그인"),
            )
          ],
        ),
      );
    } else {
      setState(() {
        errorMessage = "등록되지 않은 이메일 입니다.";
        emailController.clear();
      });
    }
  }

  void startLockTimer() {
    remainingSeconds = 180;
    countdownTimer?.cancel();
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds <= 1) {
        timer.cancel();
        setState(() {
          isLocked = false;
          attemptCount = 0;
          errorMessage = "";
        });
      } else {
        setState(() {
          remainingSeconds--;
        });
      }
    });
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("비밀번호 찾기")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "가입한 이메일을 입력하세요."),
              enabled: !isLocked,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: isLocked ? null : tryFindPw,
              child: const Text("비밀번호 찾기"),
            ),
            const SizedBox(height: 12),
            if (errorMessage.isNotEmpty)
              Text(
                errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 8),
            if (!isLocked && attemptCount > 0)
              Text("남은 시도 횟수: ${5 - attemptCount}회"),
            if (isLocked)
              Text("남은 시간: $remainingSeconds초", style: const TextStyle(color: Colors.orange)),
          ],
        ),
      ),
    );
  }
}
