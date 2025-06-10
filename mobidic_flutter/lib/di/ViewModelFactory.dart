import 'package:flutter/cupertino.dart';
import 'package:mobidic_flutter/repository/pronunciation_repository.dart';
import 'package:mobidic_flutter/repository/rate_repository.dart';
import 'package:mobidic_flutter/repository/vocab_repository.dart';
import 'package:mobidic_flutter/repository/word_repository.dart';
import 'package:mobidic_flutter/viewmodel/pronunciation_view_model.dart';
import 'package:mobidic_flutter/viewmodel/vocab_view_model.dart';
import 'package:mobidic_flutter/viewmodel/word_view_model.dart';
import 'package:provider/provider.dart';

class ViewModelFactory{
  static VocabViewModel getVocabViewModel(BuildContext context) {
    return VocabViewModel(
      context.read<VocabRepository>(),
      context.read<RateRepository>(),
    );
  }

  static WordViewModel getWordViewModel(BuildContext context, VocabViewModel vocabViewModel){
    return WordViewModel(
      context.read<WordRepository>(),
      context.read<RateRepository>(),
      vocabViewModel,
    );
  }

  static PronunciationViewModel getPronunciationViewModel(BuildContext context, VocabViewModel vocabViewModel){
    return PronunciationViewModel(
        context.read<PronunciationRepository>(),
        context.read<WordRepository>(),
        context.read<RateRepository>(),
        vocabViewModel,
      );
  }
}