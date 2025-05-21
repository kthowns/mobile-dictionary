import 'package:flutter/material.dart';
import 'find_id_page.dart'; // ❌ 필요 없어졌지만, 추후 사용할 수도 있으므로 유지
import 'find_pw_page.dart'; // ❌ 필요 없어졌지만, 추후 사용할 수도 있으므로 유지

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  void handleLogin() async {
    setState(() => isLoading = true);
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final email = emailController.text;
    final password = passwordController.text;
    final success = (email == 'testid' && password == 'testpassword');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          success ? '✅ 로그인 성공' : '❌ 로그인 실패',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(success
            ? '환영합니다, $email 님!'
            : '아이디 또는 비밀번호가 잘못되었습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        title: const Text('로그인', style: TextStyle(color: Colors.black)),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Image.asset('assets/images/mobidic_icon.png', height: 100)),
            const SizedBox(height: 20),
            const Text(
              '안녕하세요\nMOBIDIC 입니다.',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '회원 서비스 이용을 위해 로그인 해주세요.',
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                hintText: '아이디를 입력해주세요',
                border: UnderlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: '비밀번호를 입력해주세요',
                border: UnderlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signup');
                },
                child: const Text('회원가입', style: TextStyle(color: Colors.black54)),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading ? null : handleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
                    : const Text(
                  '로그인',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
