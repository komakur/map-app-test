part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class WriteUser extends UserEvent {
  final String email;
  final double longitude;
  final double latitude;
  final String uuid;
  final String avatarUrl;

  const WriteUser(this.uuid, this.avatarUrl,
      {required this.email, required this.longitude, required this.latitude});

  @override
  List<Object> get props => [email, longitude, latitude, uuid, avatarUrl];
}

class LoadUsers extends UserEvent {}

class UpdateUsers extends UserEvent {
  final List<User> users;

  const UpdateUsers(this.users);

  @override
  List<Object> get props => [users];
}
