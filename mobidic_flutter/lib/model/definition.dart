import 'package:mobidic_flutter/type/part_of_speech.dart';

class Definition {
  String id;
  String wordId;
  String definition;
  PartOfSpeech part;

  Definition({
    required this.id,
    required this.wordId,
    required this.definition,
    required this.part
  });
}