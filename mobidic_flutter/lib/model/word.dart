import 'package:mobidic_flutter/model/definition.dart';
import 'package:mobidic_flutter/type/difficulty.dart';

class Word {
  String id;
  String vocabId;
  String expression;
  Difficulty difficulty;
  List<Definition> defs;
  DateTime? createdAt;

  Word({
    required this.id,
    required this.vocabId,
    required this.expression,
    required this.difficulty,
    required this.defs,
    required this.createdAt,
  });

  factory Word.fromJson(
    Map<String, dynamic> json,
    Difficulty difficulty,
    List<Definition> defs,
  ) => Word(
      id: json['id'],
    vocabId: json['vocabId'],
    expression: json['expression'],
    difficulty: json['difficulty'],
    defs: defs,
    createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null
  );
}
