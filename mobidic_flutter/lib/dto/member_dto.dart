class MemberDto {
  final String id;
  final String email;
  final String nickname;
  final DateTime? createdAt;

  MemberDto({required this.id, required this.email,
    required this.nickname, required this.createdAt});

  factory MemberDto.fromJson(Map<String, dynamic> json) =>
    MemberDto(
      id: json['id'],
      email: json['email'],
      nickname: json['nickname'],
      createdAt: DateTime.parse(json['createdAt'])
    );
}