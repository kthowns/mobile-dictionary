import 'package:flutter/material.dart';
import 'dart:async';

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

  void tryFindPw() {
    if (isLocked) return;

    String email = emailController.text.trim();

    setState(() {
      attemptCount++;
    });

    if (attemptCount > 5) {
      setState(() {
        isLocked = true;
        errorMessage = "시도 횟수 5회를 초과했습니다. 3분 후, 다시 시도해주세요.";
      });

      Timer(const Duration(minutes: 3), () {
        setState(() {
          isLocked = false;
          attemptCount = 0;
          errorMessage = "";
        });
      });

      return;
    }

    if (email == "junseok@test.com") {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("비밀번호 찾기"),
          content: const Text("당신의 비밀벊호는: testpassword입니다."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("확인"),
            )
          ],
        ),
      );
    } else {
      setState(() {
        errorMessage = "등록되지 않은 이메일 입니다.";
      });
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("비밀번호 찾기")),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFb2ebf2),
              Color(0xFF81d4fa),
              Color(0xFF4fc3f7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "가입한 이메일을 입력하세요."),
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
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey[300],
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              Icon(Icons.note, color: Colors.black),
              Icon(Icons.home, color: Colors.black),
              Icon(Icons.exit_to_app, color: Colors.black),
            ],
          ),
        ),
      ),
    );
  }
}
