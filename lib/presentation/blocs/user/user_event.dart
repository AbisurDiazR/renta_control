import 'package:equatable/equatable.dart';
import 'package:renta_control/domain/models/user/user.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class FetchUsers extends UserEvent {}

class AddUser extends UserEvent {
  final User user;

  const AddUser({ required this.user });

  @override
  List<Object> get props => [user];
}

class UpdateUser extends UserEvent {
  final User user;

  const UpdateUser({required this.user});

  @override
  List<Object> get props => [user];
}

class SearchUsers extends UserEvent {
  final String query;

  const SearchUsers({required this.query});

  @override
  List<Object> get props => [query];
}

class UsersUpdated extends UserEvent {
  final List<User> users;

  const UsersUpdated({required this.users});

  @override
  List<Object> get props => [users];
}

class DeleteUser extends UserEvent {
  final String id;

  const DeleteUser({required this.id});

  @override
  List<Object> get props => [id];
}