// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      uuid: json['uuid'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatarUrl'] as String? ?? '',
      location: json['location'] == null
          ? null
          : Location.fromJson(json['location'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'uuid': instance.uuid,
      'email': instance.email,
      'avatarUrl': instance.avatarUrl,
      'location': instance.location?.toJson(),
    };
