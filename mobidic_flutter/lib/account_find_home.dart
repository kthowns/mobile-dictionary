import 'package:flutter/material.dart';

class AccountFindHome extends StatelessWidget {
  const AccountFindHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("계정 찾기"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/find/id');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple[100],
                  foregroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text("아이디 찾기"),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/find/pw');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple[100],
                  foregroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text("비밀번호 재설정"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}