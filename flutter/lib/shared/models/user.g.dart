// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String,
      email: json['email'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      role: $enumDecode(_$UserRoleEnumMap, json['role']),
      phone: json['phone'] as String?,
      profileComplete: (json['profile_complete'] as num?)?.toInt() ?? 0,
      profileImageUrl: json['profile_image_url'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'role': _$UserRoleEnumMap[instance.role]!,
      'phone': instance.phone,
      'profile_complete': instance.profileComplete,
      'profile_image_url': instance.profileImageUrl,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

const _$UserRoleEnumMap = {
  UserRole.coach: 'coach',
  UserRole.client: 'client',
};
