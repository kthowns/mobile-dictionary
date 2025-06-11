import 'package:flutter/material.dart';
import 'package:mobidic_flutter/di/providers.dart';
import 'package:mobidic_flutter/repository/auth_repository.dart';
import 'package:mobidic_flutter/view/auth/join_page.dart';
import 'package:mobidic_flutter/view/auth/log_in_page.dart';
import 'package:mobidic_flutter/view/learning/phonics_page.dart';
import 'package:mobidic_flutter/viewmodel/join_view_model.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MultiProvider(providers: providers, child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobidic',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',

      routes: {
        '/': (context) => LoginPage(),
        '/sign_up':
            (context) => ChangeNotifierProvider(
              create: (_) => JoinViewModel(context.read<AuthRepository>()),
              child: JoinPage(),
            ),
        '/phonics': (context) => PhonicsPage(),
      },
    );
  }
}
