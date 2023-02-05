import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'location.dart';

part 'user.g.dart';

const defaultAvatarUrl =
    'https://images.unsplash.com/photo-1675310455109-df80d0a31330?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=735&q=80';

@JsonSerializable(explicitToJson: true)
class User extends Equatable {
  final String uuid;
  final String email;
  final String username;
  final String avatarUrl;
  final Location location;

  User(
      {required this.uuid,
      required this.email,
      String? username,
      String? avatarUrl,
      this.location = const Location(latitude: 0, longitude: 0)})
      : username = username ?? _createInitialUsername(email),
        avatarUrl = avatarUrl ?? defaultAvatarUrl;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  static String _createInitialUsername(String email) {
    final wholeStringTillMailChar = RegExp(r'^[^@]*');
    final username = wholeStringTillMailChar.firstMatch(email)!.group(0);
    return username ?? '';
  }

  @override
  List<Object?> get props => [uuid, email, avatarUrl, location];
}
