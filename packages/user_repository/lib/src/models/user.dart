import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'location.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User extends Equatable {
  final String uuid;
  final String email;
  final String? avatarUrl;
  final Location? location;

  User(
      {required this.uuid, required this.email, this.avatarUrl, this.location});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  List<Object?> get props => [uuid, email, avatarUrl, location];
}
