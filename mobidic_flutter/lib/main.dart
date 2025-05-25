import 'package:flutter/material.dart';
import 'package:mobidic_flutter/data/secure_storage_data_source.dart';
import 'package:mobidic_flutter/repository/auth_repository.dart';
import 'package:mobidic_flutter/repository/member_repository.dart';
import 'package:mobidic_flutter/view/auth/join_page.dart';
import 'package:mobidic_flutter/view/auth/log_in_page.dart';
import 'package:mobidic_flutter/view/list/vocab_list_page.dart';
import 'package:mobidic_flutter/viewmodel/auth_view_model.dart';
import 'package:mobidic_flutter/viewmodel/join_view_model.dart';
import 'package:provider/provider.dart';

import 'data/api_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const String apiBaseUrl = 'http://www.mobidic.shop/api';

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => ApiClient(apiBaseUrl)),
        Provider(create: (_) => SecureStorageDataSource()),
        Provider(
          create:
              (context) => AuthRepository(
                context.read<SecureStorageDataSource>(),
                context.read<ApiClient>(),
              ),
        ),
        Provider(
          create:
              (context) => MemberRepository(
                context.read<ApiClient>(),
                context.read<AuthRepository>(),
              ),
        ),
        ChangeNotifierProvider(
          create:
              (context) => AuthViewModel(
                context.read<AuthRepository>(),
                context.read<MemberRepository>(),
              ),
        ),
      ],
      child: const MyApp(),
    ),
  );
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
        '/vocab_list': (context) => VocabListPage(),
        '/sign_up':
            (context) => ChangeNotifierProvider(
              create: (_) => JoinViewModel(
                context.read<AuthRepository>()
              ),
              child: JoinPage(),
            ),
      },
    );
  }
}
