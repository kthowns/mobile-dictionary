import 'package:flutter/material.dart';

class FindIdPage extends StatefulWidget {
  const FindIdPage({super.key});

  @override
  State<FindIdPage> createState() => _FindIdPageState();
}

class _FindIdPageState extends State<FindIdPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  void tryFindId() {
    String name = nameController.text.trim();
    String email = emailController.text.trim();

    // 예시: 고정된 더미 계정
    if (name == "yjs" && email == "junseok@test.com") {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("아이디 찾기 결과"),
          content: const Text("당신의 아이디는: junseok123"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("확인"),
            )
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("정보 확인 실패"),
          content: const Text("등록되지 않은 계정입니다."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("다시 시도"),
            )
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("아이디 찾기")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "본명을 입력하세요."),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "가입한 이메일을 입력하세요."),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: tryFindId,
              child: const Text("아이디 찾기"),
            ),
          ],
        ),
      ),
    );
  }
}
