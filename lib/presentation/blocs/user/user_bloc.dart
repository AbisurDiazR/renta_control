import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:renta_control/data/repositories/users/user_repository.dart';
import 'package:renta_control/domain/models/user/user.dart';
import 'package:renta_control/presentation/blocs/user/user_event.dart';
import 'package:renta_control/presentation/blocs/user/user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;
  StreamSubscription<List<User>>? _usersSubscription;

  UserBloc({required this.userRepository}) : super(UserInitial()) {
    on<FetchUsers>(_onFetchUsers);
    on<UsersUpdated>(_onUsersUpdated);
    on<AddUser>(_onAddUser);
    on<UpdateUser>(_onUpdateUser);
    on<SearchUsers>(_onSearchUsers);
  }

  FutureOr<void> _onFetchUsers(FetchUsers event, Emitter<UserState> emit) {
    _usersSubscription = userRepository.fetchUsers().listen(
      (users) {
        add(UsersUpdated(users: users));
      },
      onError: (error) {
        emit(UserError(message: 'Error loading users: $error'));
      },
    );
  }

  FutureOr<void> _onUsersUpdated(UsersUpdated event, Emitter<UserState> emit) {
    emit(UserLoaded(users: event.users));
  }

  FutureOr<void> _onAddUser(AddUser event, Emitter<UserState> emit) {
    try {
      userRepository.addUser(event.user);
    } catch (e) {
      emit(UserError(message: 'Error adding user: $e'));
    }
  }

  FutureOr<void> _onUpdateUser(UpdateUser event, Emitter<UserState> emit) {
    try {
      userRepository.updateUser(event.user);
    } catch (e) {
      emit(UserError(message: 'Error updating user: $e'));
    }
  }

  FutureOr<void> _onSearchUsers(SearchUsers event, Emitter<UserState> emit) {
    final currentSate = state as UserLoaded;
    final query = event.query.toLowerCase();
    final filteredUsers =
        currentSate.users.where((user) {
          return user.name.toLowerCase().contains(query) ||
              user.email.toLowerCase().contains(query);
        }).toList();
    emit(UserLoaded(users: filteredUsers));
  }

  @override
  Future<void> close() {
    _usersSubscription?.cancel();
    return super.close();
  }
}
