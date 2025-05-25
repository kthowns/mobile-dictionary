import 'package:mobidic_flutter/dto/vocab_dto.dart';

class Vocab {
  final String id;
  final String memberId;
  final String title;
  final String description;
  final double learningRate;
  final DateTime? createdAt;

  Vocab({
    required this.id,
    required this.memberId,
    required this.title,
    required this.description,
    required this.learningRate,
    required this.createdAt,
  });

  factory Vocab.fromDto(VocabDto dto, double learningRate) => Vocab(
    id: dto.id,
    memberId: dto.memberId,
    title: dto.title,
    description: dto.description,
    learningRate: learningRate,
    createdAt: dto.createdAt,
  );
}
