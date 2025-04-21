import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Whale Login',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  void handleLogin() async {
    setState(() => isLoading = true);
    await Future.delayed(Duration(seconds: 2));

    final email = emailController.text;
    final password = passwordController.text;

    if (email == 'testid' && password == 'testpassword') {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('\u2705 로그인 성공'),
          content: Text('환영합니다, $email 님!'),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('확인'))],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('\u274C 로그인 실패'),
          content: Text('아이디 또는 비밀번호가 잘못되었습니다.'),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('다시 시도'))],
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
                Image.asset('assets/whale.png', height: 150),
                SizedBox(height: 30),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Login ID',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
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
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('아이디/비밀번호 찾기'),
                        content: Text('해당 기능은 추후 구현 예정입니다.'),
                        actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('확인'))],
                      ),
                    ),
                    child: Text('아이디/비밀번호 찾기'),
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

class SignUpPage extends StatelessWidget {
  final TextEditingController newIdController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('회원가입')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: newIdController,
              decoration: InputDecoration(
                labelText: '새 아이디',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: '비밀번호',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: '비밀번호 확인',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                final id = newIdController.text;
                final pass = newPasswordController.text;
                final confirm = confirmPasswordController.text;

                String message;
                if (id.isEmpty || pass.isEmpty || confirm.isEmpty) {
                  message = '모든 항목을 입력해주세요.';
                } else if (pass != confirm) {
                  message = '비밀번호가 일치하지 않습니다.';
                } else {
                  message = '회원가입이 완료되었습니다!';
                }

                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text('알림'),
                    content: Text(message),
                    actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('확인'))],
                  ),
                );
              },
              child: Text('회원가입 완료'),
            ),
          ],
        ),
      ),
    );
  }
}

