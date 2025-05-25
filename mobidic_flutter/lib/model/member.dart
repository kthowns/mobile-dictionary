class Member {
  final String id;
  final String email;
  final String nickname;
  final DateTime? createdAt;

  Member({
    required this.id,
    required this.email,
    required this.nickname,
    required this.createdAt,
  });

  factory Member.fromJson(Map<String, dynamic> json) => Member(
    id: json['id'],
    email: json['email'],
    nickname: json['nickname'],
    createdAt:
        json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
  );
}
