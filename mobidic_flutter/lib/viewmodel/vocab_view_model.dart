import 'package:flutter/cupertino.dart';
import 'package:mobidic_flutter/model/rate.dart';
import 'package:mobidic_flutter/model/vocab.dart';
import 'package:mobidic_flutter/repository/rate_repository.dart';
import 'package:mobidic_flutter/repository/vocab_repository.dart';

class VocabViewModel extends ChangeNotifier {
  final VocabRepository _vocabRepository;
  final RateRepository _rateRepository;

  final List<String> sortOptions = ['최신순', '알파벳순', '학습률순'];
  int currentSortIndex = 0;

  void cycleSortOption() {
    currentSortIndex = (currentSortIndex + 1) % sortOptions.length;
    switch (sortOptions[currentSortIndex]) {
      case '알파벳순':
        comparator = (a, b) => a.title.compareTo(b.title);
        break;
      case '학습률순':
        comparator = (a, b) => a.learningRate.compareTo(b.learningRate);
        break;
      case '최신순':
        comparator = (a, b) => a.createdAt!.compareTo(b.createdAt!);
        break;
    }
    sort();
  }

  List<Vocab> _vocabs = [];

  List<Vocab> get vocabs => _vocabs;

  bool _editMode = false;

  bool get editMode => _editMode;

  double _accuracy = 0.0;
  double get accuracy => _accuracy;

  void toggleEditMode() {
    _editMode = !_editMode;
    notifyListeners();
  }

  Comparator<Vocab> comparator =
      (v1, v2) => v1.createdAt!.compareTo(v2.createdAt!);

  int selectedCardIndex = -1;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  VocabViewModel(
      this._vocabRepository,
      this._rateRepository
      ) {
    init();
  }

  void getQuizAccuracy() async {
    _accuracy = await _rateRepository.getAccuracyOfAll();
  }

  double getAvgLearningRate() {
    double result = 0;
    for (Vocab vocab in vocabs) {
      result += vocab.learningRate;
    }
    return result / vocabs.length;
  }

  Future<void> init() async {
    await readVocabs();
  }

  Future<void> addVocab(String title, String description) async {
    await _vocabRepository.addVocab(title, description);
    await readVocabs();
  }

  Future<void> updateVocab(
    String vocabId,
    String title,
    String description,
  ) async {
    await _vocabRepository.updateVocab(vocabId, title, description);
    await readVocabs();
  }

  Future<void> deleteVocab(String vocabId) async {
    await _vocabRepository.deleteVocab(vocabId);
    await readVocabs();
  }

  Future<void> readVocabs() async {
    _roadStart();
    _vocabs = await _vocabRepository.getVocabs();
    sort();
    getQuizAccuracy();
    _roadStop();
  }

  void sort() {
    _vocabs.sort(comparator);
    notifyListeners();
  }

  void _roadStart() {
    _isLoading = true;
  }

  void _roadStop() {
    _isLoading = false;
    notifyListeners();
  }
}
