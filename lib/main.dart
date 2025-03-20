import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:renta_control/data/repositories/auth_repository.dart';
import 'package:renta_control/data/repositories/property_repository.dart';
import 'package:renta_control/firebase_options.dart';
import 'package:renta_control/presentation/blocs/auth/auth_bloc.dart';
import 'package:renta_control/presentation/blocs/auth/auth_event.dart';
import 'package:renta_control/presentation/blocs/auth/auth_state.dart';
import 'package:renta_control/presentation/blocs/properties/property_bloc.dart';
import 'package:renta_control/presentation/pages/home_page.dart';
import 'package:renta_control/presentation/pages/login_page.dart';

//Configuración de la instancia de inyección de dependencias
final getIt = GetIt.instance;

void setupLocator() {
  //Registra todos los repositorios o servicios según sea necesario
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepository());  
  getIt.registerLazySingleton<PropertyRepository>(() => PropertyRepository());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((value) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    setupLocator();
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (_) => getIt<AuthRepository>(),
        ),
        RepositoryProvider(
          create: (_) => getIt<PropertyRepository>(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>()
            )..add(AppStarted()),
          ),
          BlocProvider(
            create: (context) => PropertyBloc(
              repository: context.read<PropertyRepository>()
            ),
          ),
        ],
        child: MaterialApp(
          title: 'Renta Control',
          theme: ThemeData(primarySwatch: Colors.blue),
          home: AppNavigator(),
        ),
      ),
    );
  }
}

class AppNavigator extends StatelessWidget {
  const AppNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        } else if (state is Unauthenticated) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        }
      },
      child: Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
