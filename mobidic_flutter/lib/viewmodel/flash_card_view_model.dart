import 'package:flutter/cupertino.dart';
import 'package:mobidic_flutter/viewmodel/vocab_view_model.dart';

import '../repository/word_repository.dart';

class FlashCardViewModel extends ChangeNotifier {
  final WordRepository _wordRepository;
  final VocabViewModel _vocabViewModel;

  FlashCardViewModel(
      this._wordRepository,
      this._vocabViewModel,
  );
}