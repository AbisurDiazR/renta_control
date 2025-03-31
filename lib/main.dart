import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:renta_control/data/repositories/auth/auth_repository.dart';
import 'package:renta_control/data/repositories/contract/contract_repository.dart';
import 'package:renta_control/data/repositories/owner/owner_repository.dart';
import 'package:renta_control/data/repositories/property/property_repository.dart';
import 'package:renta_control/firebase_options.dart';
import 'package:renta_control/presentation/blocs/auth/auth_bloc.dart';
import 'package:renta_control/presentation/blocs/auth/auth_event.dart';
import 'package:renta_control/presentation/blocs/auth/auth_state.dart';
import 'package:renta_control/presentation/blocs/contracts/contract_bloc.dart';
import 'package:renta_control/presentation/blocs/owners/owner_bloc.dart';
import 'package:renta_control/presentation/blocs/properties/property_bloc.dart';
import 'package:renta_control/presentation/pages/home_page.dart';
import 'package:renta_control/presentation/pages/login_page.dart';
import 'package:renta_control/presentation/pages/splash_page.dart';

//Configuración de la instancia de inyección de dependencias
final getIt = GetIt.instance;

void setupLocator() {
  //Registra todos los repositorios o servicios según sea necesario
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepository());
  getIt.registerLazySingleton<PropertyRepository>(() => PropertyRepository());
  getIt.registerLazySingleton<ContractRepository>(() => ContractRepository());
  getIt.registerLazySingleton<OwnerRepository>(() => OwnerRepository());
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
        RepositoryProvider(create: (_) => getIt<PropertyRepository>()),
        RepositoryProvider(create: (_) => getIt<ContractRepository>()),
        RepositoryProvider(create: (_) => getIt<OwnerRepository>()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create:
                (context) =>
                    AuthBloc(authRepository: context.read<AuthRepository>())
                      ..add(AppStarted()),
          ),
          BlocProvider(
            create:
                (context) => PropertyBloc(
                  repository: context.read<PropertyRepository>(),
                ),
          ),
          BlocProvider(
            create:
                (context) => ContractBloc(
                  repository: context.read<ContractRepository>(),
                ),
          ),
          BlocProvider(
            create:
                (context) =>
                    OwnerBloc(repository: context.read<OwnerRepository>()),
          ),
        ],
        child: MaterialApp(
          title: 'Renta Control',
          theme: ThemeData(primarySwatch: Colors.blue),
          initialRoute: '/',
          routes: {
            '/': (context) => SplashPage(),
            '/home': (context) => HomePage(),
            '/login': (context) => LoginPage(),
          },
          //home: AppNavigator(),
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
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        } else if (state is Unauthenticated) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/login',
            (route) => false,
          );
        }
      },
      child: Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
