import 'package:flutter/material.dart';
import 'package:mobidic_flutter/di/ViewModelFactory.dart';
import 'package:mobidic_flutter/type/quiz_type.dart';
import 'package:mobidic_flutter/view/auth/join_page.dart';
import 'package:mobidic_flutter/view/learning/pronunciation_check_page.dart';
import 'package:mobidic_flutter/view/list/vocab_list_page.dart';
import 'package:mobidic_flutter/view/list/word_list_page.dart';
import 'package:mobidic_flutter/view/quiz/fill_blank_quiz.dart';
import 'package:mobidic_flutter/view/quiz/flash_card_page.dart';
import 'package:mobidic_flutter/view/quiz/ox_quiz_page.dart';
import 'package:mobidic_flutter/viewmodel/auth_view_model.dart';
import 'package:mobidic_flutter/viewmodel/vocab_view_model.dart';
import 'package:provider/provider.dart';

class NavigationHelper {
  static void navigateToJoin(BuildContext context) {
    const String routeName = '/join';

    final provider = MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ViewModelFactory.getJoinViewModel(context),
        ),
      ],
      child: JoinPage(),
    );

    _navigateTo(context, provider, routeName);
  }

  static void navigateToVocabList(
    BuildContext context,
    AuthViewModel authViewModel,
  ) {
    const String routeName = '/vocab_list';

    final provider = MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create:
              (_) => ViewModelFactory.getVocabViewModel(context, authViewModel),
        ),
      ],
      child: VocabListPage(),
    );

    _navigateTo(context, provider, routeName);
  }

  static void navigateToWordList(
    BuildContext context,
    VocabViewModel vocabViewModel,
    int index,
  ) {
    const String routeName = '/word_list';
    vocabViewModel.selectVocabAt(index);

    final MultiProvider provider = MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create:
              (_) => ViewModelFactory.getWordViewModel(context, vocabViewModel),
        ),
      ],
      child: WordListPage(),
    );

    _navigateTo(context, provider, routeName);
  }

  static void navigateToPronunciationCheck(
    BuildContext context,
    VocabViewModel vocabViewModel,
    int index,
  ) {
    const String routeName = '/pronunciation_check';
    vocabViewModel.selectVocabAt(index);

    final MultiProvider provider = MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create:
              (_) => ViewModelFactory.getPronunciationViewModel(
                context,
                vocabViewModel,
              ),
        ),
      ],
      child: PronunciationCheckPage(),
    );

    _navigateTo(context, provider, routeName);
  }

  static void navigateToFlashCard(
    BuildContext context,
    VocabViewModel vocabViewModel,
    int index,
  ) {
    vocabViewModel.selectVocabAt(index);
    const String routeName = '/flash_card';

    final provider = MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create:
              (_) => ViewModelFactory.getFlashCardViewModel(
                context,
                vocabViewModel,
              ),
        ),
      ],
      child: FlashCardPage(),
    );

    _navigateTo(context, provider, routeName);
  }

  static void navigateToQuiz(
    BuildContext context,
    VocabViewModel vocabViewModel,
    int index,
    QuizType quizType,
  ) {
    vocabViewModel.selectVocabAt(index);
    final String routeName = '/${quizType.name}_quiz';

    final provider = MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create:
              (_) => switch (quizType) {
                QuizType.OX => ViewModelFactory.getOxQuizViewModel(
                  context,
                  vocabViewModel,
                ),
                QuizType.DICTATION => throw UnimplementedError(),
                QuizType.BLANK => throw UnimplementedError(),
                _ => throw UnimplementedError(),
              },
        ),
      ],
      child: switch (quizType) {
        QuizType.OX => OxQuizPage(),
        QuizType.BLANK => FillBlankQuizPage(),
        _ => throw UnimplementedError(),
      },
    );

    _navigateTo(context, provider, routeName);
  }

  static void _navigateTo(
    BuildContext context,
    MultiProvider provider,
    String routeName,
  ) {
    print(provider);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => provider,
        settings: RouteSettings(name: routeName),
      ),
    );
  }
}
