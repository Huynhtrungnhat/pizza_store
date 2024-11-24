class User {
  final int id;
  final String name;
  final String email;
  late final String quyen;
  final String? emailVerifiedAt;
  final String createdAt;
  final String updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.quyen,

    this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      quyen: json['quyen'],
      emailVerifiedAt: json['email_verified_at'],
      createdAt: json['created_at'],  
      updatedAt: json['updated_at'],
    );
  }
}
