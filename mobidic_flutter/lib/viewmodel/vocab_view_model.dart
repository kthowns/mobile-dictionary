import 'package:flutter/cupertino.dart';
import 'package:mobidic_flutter/model/vocab.dart';
import 'package:mobidic_flutter/repository/rate_repository.dart';
import 'package:mobidic_flutter/repository/vocab_repository.dart';

class VocabViewModel extends ChangeNotifier {
  final VocabRepository _vocabRepository;
  final RateRepository _rateRepository;
  final TextEditingController searchController = TextEditingController();

  VocabViewModel(this._vocabRepository, this._rateRepository) {
    init();
  }

  Future<void> init() async {
    await readVocabs();
    searchController.addListener(() {
      searchVocabs();
    });
  }

  Future<void> readVocabs() async {
    _roadStart();
    _vocabs = await _vocabRepository.getVocabs();
    searchVocabs();
    sort();
    _accuracy = await getQuizAccuracy();
    _roadStop();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

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

  Vocab? currentVocab;

  List<Vocab> _vocabs = [];

  List<Vocab> get vocabs => _vocabs;

  List<Vocab> _showingVocabs = [];

  List<Vocab> get showingVocabs => _showingVocabs;

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

  void searchVocabs() {
    String keyword = searchController.text;
    print("searchVocab() : " + keyword);
    if (keyword.isEmpty) {
      _showingVocabs = _vocabs;
    }
    final query = searchController.text.toLowerCase();
    _showingVocabs =
        _vocabs
            .where(
              (v) =>
                  v.title.toLowerCase().contains(query) ||
                  v.description.toLowerCase().contains(query),
            )
            .toList();
    notifyListeners();
  }

  Future<double> getQuizAccuracy() async {
    return await _rateRepository.getAccuracyOfAll();
  }

  double getAvgLearningRate() {
    double result = 0;
    for (Vocab vocab in vocabs) {
      result += vocab.learningRate;
    }
    return result / vocabs.length;
  }

  Future<void> addVocab(String title, String description) async {
    await _vocabRepository.addVocab(title, description);
    await readVocabs();
  }

  Future<void> updateVocab(
    Vocab vocab,
    String title,
    String description,
  ) async {
    await _vocabRepository.updateVocab(vocab.id, title, description);
    await readVocabs();
  }

  Future<void> deleteVocab(Vocab vocab) async {
    await _vocabRepository.deleteVocab(vocab.id);
    await readVocabs();
  }

  void sort() {
    _vocabs.sort(comparator);
    searchVocabs();
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
