import 'package:flutter/cupertino.dart';
import 'package:mobidic_flutter/model/vocab.dart';
import 'package:mobidic_flutter/repository/vocab_repository.dart';

class VocabViewModel extends ChangeNotifier {
  final VocabRepository _vocabRepository;

  List<Vocab> _vocabs = [];

  List<Vocab> get vocabs => _vocabs;

  Comparator<Vocab> comparator =
      (v1, v2) => v1.createdAt!.compareTo(v2.createdAt!);

  int selectedCardIndex = -1;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  VocabViewModel(this._vocabRepository) {
    init();
  }

  double getQuizAccuracy(){
    return 0.67;
  }

  double getAvgLearningRate(){
    double result = 0;
    for(Vocab vocab in vocabs){
      result += vocab.learningRate;
    }
    return result/vocabs.length;
  }

  Future<void> init() async {
    await readVocabs();
  }

  Future<void> addVocab(
    String title,
    String description,
  ) async {
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
