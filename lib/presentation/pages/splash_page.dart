import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:renta_control/presentation/blocs/auth/auth_bloc.dart';
import 'package:renta_control/presentation/blocs/auth/auth_state.dart';

class SplashPage extends StatelessWidget{
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is Authenticated) {
              Navigator.of(context).pushReplacementNamed('/home');
            } else if (state is Unauthenticated) {
              Navigator.of(context).pushReplacementNamed('/login');
            }
          },
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}