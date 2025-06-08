import 'package:flutter/cupertino.dart';
import 'package:mobidic_flutter/model/definition.dart';
import 'package:mobidic_flutter/model/word.dart';
import 'package:mobidic_flutter/repository/rate_repository.dart';
import 'package:mobidic_flutter/repository/word_repository.dart';
import 'package:mobidic_flutter/type/part_of_speech.dart';
import 'package:mobidic_flutter/viewmodel/vocab_view_model.dart';

class WordViewModel extends ChangeNotifier {
  final WordRepository _wordRepository;
  final RateRepository _rateRepository;
  final VocabViewModel _vocabViewModel;
  final TextEditingController searchController = TextEditingController();

  WordViewModel(
    this._wordRepository,
    this._rateRepository,
    this._vocabViewModel,
  ) {
    init();
  }

  Future<void> init() async {
    await loadData();
    searchController.addListener(() {
      searchWords();
    });
  }

  Future<void> loadData() async {
    _loadStart();
    _words = await _wordRepository.getWords(_vocabViewModel.currentVocab?.id);
    searchWords();
    sort();
    updateRates();
    _loadStop();
  }

  Future<void> updateRates() async {
    _accuracy = await getQuizAccuracy();
    _learningRate = await getLearningRate();
    notifyListeners();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  final List<String> sortOptions = ['최신순', '난이도순', '알파벳순'];
  int currentSortIndex = 0;

  void cycleSortOption() {
    currentSortIndex = (currentSortIndex + 1) % sortOptions.length;
    switch (sortOptions[currentSortIndex]) {
      case '알파벳순':
        comparator = (b, a) => a.expression.compareTo(b.expression);
        break;
      case '난이도순':
        comparator = (b, a) => a.difficulty.compareTo(b.difficulty);
        break;
      case '최신순':
        comparator = (b, a) => a.createdAt!.compareTo(b.createdAt!);
        break;
    }
    sort();
    searchWords();
  }

  final TextEditingController _addingExpController = TextEditingController();
  TextEditingController get addingExpController => _addingExpController;

  String _addingErrorMessage = "";
  String get addingErrorMessage => _addingErrorMessage;

  final List<DefWithPart> _addingDefs = [DefWithPart(definition: "", part: PartOfSpeech.NOUN)];
  List<DefWithPart> get addingDefs => _addingDefs;

  final TextEditingController _editingExpController = TextEditingController();
  TextEditingController get editingExpController => _editingExpController;

  String _editingErrorMessage = "";
  String get editingErrorMessage => _editingErrorMessage;

  final List<Definition> _editingDefs = [];
  List<Definition> get editingDefs => _editingDefs;

  Word? currentVocab;

  List<Word> _words = [];

  List<Word> get words => _words;

  List<Word> _showingWords = [];

  List<Word> get showingVocabs => _showingWords;

  bool _editMode = false;

  bool get editMode => _editMode;

  double _accuracy = 0.0;

  double get accuracy => _accuracy;

  double _learningRate = 0.0;

  double get learningRate => _learningRate;

  void toggleEditMode() {
    _editMode = !_editMode;
    notifyListeners();
  }

  Comparator<Word> comparator =
      (w2, w1) => w1.createdAt!.compareTo(w2.createdAt!);

  int selectedCardIndex = -1;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void searchWords() {
    String keyword = searchController.text;

    if (keyword.isEmpty) {
      _showingWords = _words;
    }
    final query = searchController.text.toLowerCase();
    _showingWords =
        _words
            .where(
              (w) =>
                  w.expression.toLowerCase().contains(query) ||
                  w.defs.any(
                    (def) => def.definition.toLowerCase().contains(query),
                  ),
            )
            .toList();
    notifyListeners();
  }

  void setAddingErrorMessage(String message){
    _addingErrorMessage = message;
    notifyListeners();
  }

  Future<double> getQuizAccuracy() async {
    return await _rateRepository.getAccuracy(_vocabViewModel.currentVocab?.id);
  }

  Future<double> getLearningRate() async {
    return await _rateRepository.getLearningRate(
      _vocabViewModel.currentVocab?.id,
    );
  }

  Future<void> addWord(String expression, List<DefWithPart> defs) async {
    await _wordRepository.addWord(
      _vocabViewModel.currentVocab,
      expression,
      defs,
    );
    await loadData();
  }

  Future<void> updateWord(Word word, List<Definition> defs) async {
    await _wordRepository.updateWord(word, defs);
    await loadData();
  }

  Future<void> deleteWord(Word word) async {
    await _wordRepository.deleteWord(word);
    await loadData();
  }

  void sort() {
    _words.sort(comparator);
    notifyListeners();
  }

  void _loadStart() {
    _isLoading = true;
    notifyListeners();
  }

  void _loadStop() {
    _isLoading = false;
    notifyListeners();
  }
}
