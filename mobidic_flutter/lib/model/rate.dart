import 'package:mobidic_flutter/type/difficulty.dart';

class RateDto {
  final String wordId;
  final int correctCount;
  final int incorrectCount;
  final int isLearned;
  final Difficulty difficulty;

  RateDto({
    required this.wordId,
    required this.correctCount,
    required this.incorrectCount,
    required this.isLearned,
    required this.difficulty,
  });

  factory RateDto.fromJson(Map<String, dynamic> json) => RateDto(
    wordId: json['wordId'],
    correctCount: json['correctCount'],
    incorrectCount: json['incorrectCount'],
    isLearned: json['isLearned'],
    difficulty: json['difficulty'],
  );
}
