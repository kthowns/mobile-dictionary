import 'package:flutter/material.dart';
import 'Log_in_page.dart'; // LoginPage 클래스가 정의된 파일 import

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
              onPressed: () {
                Navigator.pop(context); // 다이얼로그 닫기
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
      // 실패 시 입력 필드 초기화
      nameController.clear();
      emailController.clear();

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
      backgroundColor: Colors.white, // ✅ 흰 배경으로 변경
      appBar: AppBar(
        title: const Text("아이디 찾기"),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'MOBIDIC',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Center(
              child: Text(
                '아이디를 잊으셨나요? 이름과 이메일을 입력하면 찾아드립니다!',
                style: TextStyle(fontSize: 20, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "사용자 이름 입력.",
                helperText: '가입 시 입력한 이름을 입력하세요',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "이메일 입력.",
                helperText: '가입 시 사용한 이메일을 입력하세요.',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: tryFindId,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "아이디 찾기",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
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
