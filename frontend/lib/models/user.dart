class User {
  final int id;
  final String email;
  final String role;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final bool? isActive;

  User({
    required this.id,
    required this.email,
    required this.role,
    this.firstName,
    this.lastName,
    this.phone,
    this.isActive,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['userId'] ?? json['id'],
      email: json['email'],
      role: json['role'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phone: json['phone'],
      isActive: json['isActive'],
    );
  }

  bool get isAdmin => role == 'ADMIN';
  bool get isAgent => role == 'AGENT';
  bool get isUser => role == 'USER';
}

