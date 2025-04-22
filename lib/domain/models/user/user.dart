class User {
  final String? id;
  final String name;
  final String email;
  final String password;
  final String? updatedAt;
  final String? createdAt;
  final bool disabled;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    this.updatedAt,
    this.createdAt,
    this.disabled = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'updatedAt': updatedAt,
      'createdAt': createdAt,
      'disabled': disabled,
    };
  }

  factory User.fromMap(Map<String, dynamic> map, String? docId) {
    return User(
      id: docId,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      updatedAt: map['updatedAt'],
      createdAt: map['createdAt'],
      disabled: map['disabled'] ?? false,
    );
  }
}
