class AddVocabRequestDto {
  final String title;
  final String description;

  AddVocabRequestDto({required this.title, required this.description});

  Map<String, dynamic> toJson() => {'title': title, 'description': description};
}

class AddVocabResponseDto {
  final String id;
  final String title;
  final String description;

  AddVocabResponseDto({
    required this.id,
    required this.title,
    required this.description,
  });

  factory AddVocabResponseDto.fromJson(Map<String, dynamic> json) =>
      AddVocabResponseDto(
        id: json['id'],
        title: json['title'],
        description: json['description'],
      );
}
