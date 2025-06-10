import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:mobidic_flutter/model/word.dart';
import 'package:mobidic_flutter/repository/pronunciation_repository.dart';
import 'package:mobidic_flutter/repository/rate_repository.dart';
import 'package:mobidic_flutter/repository/word_repository.dart';
import 'package:mobidic_flutter/viewmodel/vocab_view_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class PronunciationViewModel extends ChangeNotifier {
  final PronunciationRepository _pronunciationRepository;
  final WordRepository _wordRepository;
  final RateRepository _rateRepository;
  final VocabViewModel _vocabViewModel;

  PronunciationViewModel(
    this._pronunciationRepository,
    this._wordRepository,
    this._rateRepository,
    this._vocabViewModel,
  ) {
    init();
  }

  Future<void> init() async {
    await loadData();
  }

  Future<void> loadData() async {
    _loadStart();
    _words = await _wordRepository.getWords(_vocabViewModel.currentVocab?.id);
    if(_words.length < 2){
      _isEnd = true;
    }
    _loadStop();
  }

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<Word> _words = [];

  List<Word> get words => _words;

  int currentWordIndex = 0;

  final _recorder = AudioRecorder();

  bool _isRecording = false;

  bool get isRecording => _isRecording;

  String recordFilePath = "";

  String score = "점";

  bool _isEnd = false;
  bool get isEnd => _isEnd;

  Future<void> startRecording() async {
    final dir = await getTemporaryDirectory();
    recordFilePath = '${dir.path}/temp_audio.mp4';
    if (await _recorder.hasPermission()) {
      final config = RecordConfig(
        encoder: AudioEncoder.aacLc, // aacADTS도 가능
        bitRate: 128000,
        sampleRate: 44100,
      );

      await _recorder.start(config, path: recordFilePath);
    } else {
      print("NO Permission!!");
    }
    _isRecording = true;
    notifyListeners();
  }

  Future<void> stopRecordingAndUpload() async {
    final path = await _recorder.stop();

    await Future.delayed(Duration(milliseconds: 500));
    _isRecording = false;
    notifyListeners();

    if (path != null) {
      final File file = File(path);

      // 파일 존재 확인
      if (await file.exists()) {
        final bytes = await file.readAsBytes(); // 정확한 byte[]
        final size = bytes.length;
        print("확실한 byte 크기: $size");

        try {
          String responseScore = score = await _pronunciationRepository.checkPronunciation(
            file.path,
            words[currentWordIndex].id,
          );
          score = "$responseScore점";
        } catch (e){
          score = "오류 발생";
        }
        notifyListeners();
      }
    }
  }

  void goToNextWord() {
    currentWordIndex += 1;
    if(currentWordIndex >= words.length-1){
      _isEnd = true;
    }
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
