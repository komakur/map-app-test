import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class User extends Equatable {
  static const empty = User(uuid: '');

  final String uuid;
  final String? email;

  const User({
    required this.uuid,
    this.email,
  });

  bool get isEmpty => this == User.empty;
  bool get isNotEmpty => this != User.empty;

  factory User.fromFirebaseUser(firebase_auth.User firebaseUser) {
    return User(
      uuid: firebaseUser.uid,
      email: firebaseUser.email,
    );
  }

  @override
  List<Object?> get props => [uuid, email];
}
