import 'package:flutter/material.dart';
//import 'Find_id_pw.dart';

// 로그인 페이지
class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  // 로그인 함수
  void handleLogin() async {
    setState(() => isLoading = true);
    await Future.delayed(Duration(seconds: 2));

    final email = emailController.text;
    final password = passwordController.text;

    if (email == 'testid' && password == 'testpassword') {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(
            '\u2705 로그인 성공',
            style: TextStyle(fontFamily: 'Baloo2'), // 앱 제목 폰트
          ),
          content: Text(
            '환영합니다, $email 님!',
            style: TextStyle(fontFamily: 'MPlusRounded1c'), // 본문 폰트
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                '확인',
                style: TextStyle(fontFamily: 'Quicksand'), // 버튼 폰트
              ),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(
            '\u274C 로그인 실패',
            style: TextStyle(fontFamily: 'Baloo2'), // 앱 제목 폰트
          ),
          content: Text(
            '아이디 또는 비밀번호가 잘못되었습니다.',
            style: TextStyle(fontFamily: 'MPlusRounded1c'), // 본문 폰트
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                '다시 시도',
                style: TextStyle(fontFamily: 'Quicksand'), // 버튼 폰트
              ),
            ),
          ],
        ),
      );
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFb2ebf2), Color(0xFF81d4fa), Color(0xFF4fc3f7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Image.asset('assets/whale.png', height: 150), // 로고 이미지
                SizedBox(height: 30),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Login ID',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  style: TextStyle(fontFamily: 'MPlusRounded1c'), // 본문 폰트
                ),
                SizedBox(height: 20),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  style: TextStyle(fontFamily: 'MPlusRounded1c'), // 본문 폰트
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/find');
                    },
                    child: Text(
                      '아이디/비밀번호 찾기',
                      style: TextStyle(fontFamily: 'Quicksand'), // 버튼 텍스트 폰트
                    ),
                  ),
                ),
                SizedBox(height: 10),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      textStyle: TextStyle(fontFamily: 'Quicksand'), // 버튼 폰트
                    ),
                    child: isLoading
                        ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                        : Text('Login', style: TextStyle(fontSize: 18)),
                  ),
                ),
                SizedBox(height: 20),
                OutlinedButton(
                  onPressed: () => Navigator.pushNamed(context, '/signup'),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.blue.shade700),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    textStyle: TextStyle(fontFamily: 'Quicksand'), // 버튼 폰트
                  ),
                  child: Text('회원가입', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
