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
