/// Modèle utilisateur
class User {
  final String id;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? avatar;
  final DateTime? lastLogin;
  
  User({
    required this.id,
    required this.email,
    this.firstName,
    this.lastName,
    this.avatar,
    this.lastLogin,
  });
  
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      avatar: json['avatar'] as String?,
      lastLogin: json['lastLogin'] != null 
          ? DateTime.parse(json['lastLogin'] as String) 
          : null,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'avatar': avatar,
      'lastLogin': lastLogin?.toIso8601String(),
    };
  }
  
  String get fullName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    }
    return firstName ?? lastName ?? email;
  }
  
  User copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? avatar,
    DateTime? lastLogin,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      avatar: avatar ?? this.avatar,
      lastLogin: lastLogin ?? this.lastLogin,
    );
  }
}