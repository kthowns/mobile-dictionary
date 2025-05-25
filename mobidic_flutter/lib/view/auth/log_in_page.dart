import 'package:flutter/material.dart';
import 'package:mobidic_flutter/viewmodel/auth_view_model.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();

    void onLoggedIn() async{
      if (authViewModel.isLoggedIn) {
        Navigator.pushNamed(context, '/vocab_list');

        showDialog(
          context: context,
          builder:
              (_) => AlertDialog(
            title: const Text(
              '✅ 로그인 성공',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Text(
              '환영합니다, ${authViewModel.currentMember?.nickname} 님!',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('확인'),
              ),
            ],
          ),
        );
      }
    }

    void handleLogin() async {
      await authViewModel.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      onLoggedIn();
    }

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
            Center(
              child: Image.asset('assets/images/mobidic_icon.png', height: 100),
            ),
            const SizedBox(height: 20),
            const Text(
              '안녕하세요\nMOBIDIC 입니다.',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
            Visibility(
              visible: authViewModel.loginError,
              replacement: SizedBox.shrink(),
              child: Text(
                authViewModel.loginErrorMessage,
                style: TextStyle(color: Colors.red),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/sign_up');
                },
                child: const Text(
                  '회원가입',
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: authViewModel.isLoading ? null : handleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child:
                    authViewModel.isLoading
                        ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
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
