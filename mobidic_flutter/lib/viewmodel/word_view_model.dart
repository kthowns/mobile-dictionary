import 'package:flutter/cupertino.dart';
import 'package:mobidic_flutter/viewmodel/vocab_view_model.dart';
import 'package:mobidic_flutter/repository/word_repository.dart';

class WordViewModel extends ChangeNotifier{
  final WordRepository _wordRepository;
  final VocabViewModel _vocabViewModel;
  late final String? _currentVocabId;

  WordViewModel(this._wordRepository, this._vocabViewModel);
}
