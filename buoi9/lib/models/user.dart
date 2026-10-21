class AppUser {
  final int? id;
  final String email;
  final String password;
  final String? createdAt;

  AppUser({
    this.id,
    required this.email,
    required this.password,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'email': email,
      'password': password,
      'createdAt': createdAt ?? DateTime.now().toIso8601String(),
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'] as int?,
      email: map['email'] as String,
      password: map['password'] as String,
      createdAt: map['createdAt'] as String?,
    );
  }
}
