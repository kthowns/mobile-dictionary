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
    required this.part,
  });

  factory Definition.fromDto(DefDto dto) => Definition(
    id: dto.id,
    wordId: dto.wordId,
    definition: dto.definition,
    part: dto.part,
  );
}

class DefDto {
  final String id;
  final String wordId;
  final String definition;
  final PartOfSpeech part;

  DefDto({
    required this.id,
    required this.wordId,
    required this.definition,
    required this.part,
  });

  factory DefDto.fromJson(Map<String, dynamic> json) => DefDto(
    id: json['id'],
    wordId: json['wordId'],
    definition: json['definition'],
    part: json['part'],
  );
}
