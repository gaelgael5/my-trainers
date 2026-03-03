import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

enum UserRole {
  @JsonValue('coach')
  coach,
  @JsonValue('client')
  client
}

@JsonSerializable()
class User extends Equatable {
  final String id;
  final String email;
  @JsonKey(name: 'first_name')
  final String firstName;
  @JsonKey(name: 'last_name')
  final String lastName;
  final UserRole role;
  final String? phone;
  @JsonKey(name: 'profile_complete')
  final int profileComplete;
  @JsonKey(name: 'profile_image_url')
  final String? profileImageUrl;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  const User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    this.phone,
    this.profileComplete = 0,
    this.profileImageUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  User copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    UserRole? role,
    String? phone,
    int? profileComplete,
    String? profileImageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      profileComplete: profileComplete ?? this.profileComplete,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get fullName => '$firstName $lastName';
  
  String get initials => 
    '${firstName.isNotEmpty ? firstName[0] : ''}${lastName.isNotEmpty ? lastName[0] : ''}'.toUpperCase();
  
  bool get isCoach => role == UserRole.coach;
  bool get isClient => role == UserRole.client;
  
  bool get isProfileComplete => profileComplete >= 80;

  @override
  List<Object?> get props => [
        id,
        email,
        firstName,
        lastName,
        role,
        phone,
        profileComplete,
        profileImageUrl,
        createdAt,
        updatedAt,
      ];
}