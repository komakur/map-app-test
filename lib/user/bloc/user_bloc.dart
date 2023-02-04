import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _userRepository;
  StreamSubscription? _userSubscription;
  UserBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(UserInitial()) {
    on<WriteUser>((event, emit) async {
      emit(UserLoading());
      await _userRepository
          .addUserToFirestore(User(
              uuid: event.uuid,
              email: event.email,
              location: Location(
                  latitude: event.latitude, longitude: event.longitude),
              avatarUrl: event.avatarUrl))
          .whenComplete(() => emit(UserSuccess()));
    });
    on<LoadUsers>(
      (event, emit) async {
        _userSubscription?.cancel();
        final users = await _userRepository.getAllUsers();
        emit(UsersLoaded(users: users));
      },
    );
  }
}
