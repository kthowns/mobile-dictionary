import 'package:flutter/material.dart';
import 'package:mobidic_flutter/di/ViewModelFactory.dart';
import 'package:mobidic_flutter/repository/rate_repository.dart';
import 'package:mobidic_flutter/repository/vocab_repository.dart';
import 'package:mobidic_flutter/view/learning/pronunciation_check_page.dart';
import 'package:mobidic_flutter/view/list/vocab_list_page.dart';
import 'package:mobidic_flutter/view/list/word_list_page.dart';
import 'package:mobidic_flutter/viewmodel/vocab_view_model.dart';
import 'package:provider/provider.dart';

class NavigationHelper {
  static void navigateToWordList(
    BuildContext context,
    VocabViewModel vocabViewModel,
    int index,
  ) {
    vocabViewModel.selectVocabAt(index);

    final MultiProvider provider = MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: vocabViewModel),
        ChangeNotifierProvider(
          create:
              (_) => ViewModelFactory.getWordViewModel(context, vocabViewModel),
        ),
      ],
      child: WordListPage(),
    );

    _navigateTo(context, provider);
  }

  static void navigateToPronunciationCheck(
    BuildContext context,
    VocabViewModel vocabViewModel,
    int index,
  ) {
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

    _navigateTo(context, provider);
  }

  static void navigateToVocabList(BuildContext context) {
    final provider = MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create:
              (_) => VocabViewModel(
                context.read<VocabRepository>(),
                context.read<RateRepository>(),
              ),
        ),
      ],
      child: VocabListPage(),
    );

    _navigateTo(context, provider);
  }

  static void _navigateTo(BuildContext context, MultiProvider provider) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => provider));
  }
}
