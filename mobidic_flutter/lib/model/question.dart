class Question {}

class QuestionDto {
  final String token;
  final String stem;
  final List<String> options;

  QuestionDto({required this.token, required this.stem, required this.options});

  factory QuestionDto.fromJson(Map<String, dynamic> json) => QuestionDto(
    token: json['wordId'],
    stem: json['stem'],
    options: json['options'],
  );
}
