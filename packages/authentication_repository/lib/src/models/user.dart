import 'package:equatable/equatable.dart';

class User extends Equatable {
  static const empty = User(uuid: '');

  final String uuid;
  final String? email;
  final String? name;

  final String? avatarUrl;

  const User({
    required this.uuid,
    this.email,
    this.name,
    this.avatarUrl,
  });

  bool get isEmpty => this == User.empty;
  bool get isNotEmpty => this != User.empty;

  @override
  List<Object?> get props => [uuid, email, name, avatarUrl];
}
