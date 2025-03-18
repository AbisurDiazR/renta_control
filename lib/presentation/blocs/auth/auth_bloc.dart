// ignore_for_file: unnecessary_this

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:renta_control/data/repositories/auth_repository.dart';
import 'package:renta_control/presentation/blocs/auth/auth_event.dart';
import 'package:renta_control/presentation/blocs/auth/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState>{
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()){
    // Maneja el evento de AppStarted
    on<AppStarted>((event, emit) async {
      emit(AuthLoading());
      try {
        final isSignedIn = await authRepository.isSignedIn();
        if (isSignedIn) {
          final user = await this.authRepository.getCurrentUser();
          if(user != null){
          emit(Authenticated(user));
          }else{
            emit(AuthError('Usuario no encontrado'));
          }
        }else{
          emit(Unauthenticated());
        }
      } catch (e) {
        emit(AuthError('Error al verificar el estado de autenticación.'));
      }
    });

    // Maneja el evento LoginRequested
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await this.authRepository.signIn(
          email: event.email,
          password: event.password
        );
        if(user != null){
        emit(Authenticated(user));
        }else{
          emit(AuthError('Inicio de sesión fallido. Usuario no encontrado'));
        }
      } catch (e) {
        emit(AuthError('Error al iniciar sesión. Verifique sus credenciales.'));
      }
    });

    // Maneja el evento LogoutRequested
    on<LogoutRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await this.authRepository.signOut();
        emit(Unauthenticated());
      } catch (e) {
        emit(AuthError('Error al cerrar sesión.'));
      }
    });
  }
}