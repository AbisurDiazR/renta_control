import 'package:equatable/equatable.dart';
import 'package:renta_control/data/models/user_model.dart';

// Clase abstracta que representa todos los estados de autenticación
abstract class AuthState extends Equatable{
  @override
  List<Object> get props => [];
}

// Estado inicial de la autenticación
class AuthInitial extends AuthState{}

// Estado cuando el usuario esta autenticado
class Authenticated extends AuthState{
  final UserModel user;

  Authenticated(this.user);

  @override
  List<Object> get props => ['user'];
}

// Estado cuando el usuario no esta autenticado
class Unauthenticated extends AuthState{}

// Estado cuando la authenticacion esta en proceso
class AuthLoading extends AuthState{}

// Estado cuando ocurre un error en la autenticación
class AuthError extends AuthState{
  final String message;

  AuthError(this.message);

  @override
  List<Object> get props => [message];
}
