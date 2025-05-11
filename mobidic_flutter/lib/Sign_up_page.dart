import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController newIdController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  String? emailErrorText;
  String? passwordErrorText;
  String? confirmPasswordErrorText;

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  bool isValidEmail(String email) {
    final regex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    return regex.hasMatch(email);
  }

  bool isValidPassword(String password) {
    if (password.length < 8) return false;
    final forbiddenChars = RegExp(r'[-=]');
    final specialCharRegex = RegExp(r'''[!@#\$%^&*()_+{}\[\]:;"'<>,.?/\\|`~]''');

    if (forbiddenChars.hasMatch(password)) return false;
    if (!specialCharRegex.hasMatch(password)) return false;

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '회원가입',
          style: TextStyle(fontSize: 24),
        ),
      ),
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
                controller: newIdController,
                decoration: InputDecoration(
                  labelText: '이메일 (example@naver.com)',
                  helperText: '올바른 이메일 형식을 입력하세요.',
                  errorText: emailErrorText,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: newPasswordController,
                obscureText: !isPasswordVisible,
                decoration: InputDecoration(
                  labelText: '비밀번호',
                  helperText: '8자 이상 + 특수문자 1개 이상 ( - 와 = 제외 )',
                  errorText: passwordErrorText,
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: confirmPasswordController,
                obscureText: !isConfirmPasswordVisible,
                decoration: InputDecoration(
                  labelText: '비밀번호 확인',
                  errorText: confirmPasswordErrorText,
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        isConfirmPasswordVisible = !isConfirmPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  final id = newIdController.text.trim();
                  final pass = newPasswordController.text;
                  final confirm = confirmPasswordController.text;

                  setState(() {
                    emailErrorText = null;
                    passwordErrorText = null;
                    confirmPasswordErrorText = null;
                  });

                  bool hasError = false;

                  if (!isValidEmail(id)) {
                    setState(() {
                      emailErrorText = '올바른 이메일을 입력해주세요.';
                    });
                    hasError = true;
                  }

                  if (!isValidPassword(pass)) {
                    setState(() {
                      passwordErrorText = '비밀번호는 8자 이상, 특수문자 포함해야 하며 (-, =) 금지입니다.';
                    });
                    hasError = true;
                  }

                  if (pass != confirm) {
                    setState(() {
                      confirmPasswordErrorText = '비밀번호가 일치하지 않습니다.';
                    });
                    hasError = true;
                  }

                  if (hasError) return;

                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('알림'),
                      content: const Text('회원가입이 완료되었습니다!'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('확인'),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text('회원가입'),
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
