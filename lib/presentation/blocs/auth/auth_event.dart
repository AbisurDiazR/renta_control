import 'package:equatable/equatable.dart';

// Clase abstracta que representa todos los eventos de autenticación
abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

// Evento que se dispara al iniciar la aplicación para verificar el estado de autenticación
class AppStarted extends AuthEvent{}

// Evento que se dispara al iniciar sesión
class LoginRequested extends AuthEvent{
  final String email;
  final String password;

  LoginRequested(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

// Evento que se dispara al cerrar sesión
class LogoutRequested extends AuthEvent{}