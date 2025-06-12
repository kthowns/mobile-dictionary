class Question {
  final String token;
  final String stem;
  final List<String> options;

  Question({
    required this.token,
    required this.stem,
    required this.options
  });

  factory Question.fromDto(QuestionDto dto) => Question(
    token: dto.token,
    stem: dto.stem,
    options: dto.options,
  );
}

class QuestionDto {
  final String token;
  final String stem;
  final List<String> options;

  QuestionDto({required this.token, required this.stem, required this.options});

  factory QuestionDto.fromJson(Map<String, dynamic> json) => QuestionDto(
    token: json['token'],
    stem: json['stem'],
    options: List<String>.from(json['options']),
  );
}
