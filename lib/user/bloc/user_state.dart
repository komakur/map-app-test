part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserLoaded extends UserState {
  final List<User> users;
  const UserLoaded({this.users = const <User>[]});

  @override
  List<Object> get props => [users];
}

class UserLoading extends UserState {}

class UserSuccess extends UserState {}
