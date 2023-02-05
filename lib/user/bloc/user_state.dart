part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UsersLoaded extends UserState {
  final List<User> users;
  const UsersLoaded({this.users = const <User>[]});

  @override
  List<Object> get props => [users];
}

class UsersListening extends UserState {}

class UserLoading extends UserState {}

class UserSuccess extends UserState {}
