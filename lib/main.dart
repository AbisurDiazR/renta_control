// ignore_for_file: depend_on_referenced_packages

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:renta_control/data/repositories/auth/auth_repository.dart';
import 'package:renta_control/data/repositories/contract/contract_repository.dart';
import 'package:renta_control/data/repositories/guarantor/guarantor_repository.dart';
import 'package:renta_control/data/repositories/invoice/invoice_repository.dart';
import 'package:renta_control/data/repositories/owner/owner_repository.dart';
import 'package:renta_control/data/repositories/property/property_repository.dart';
import 'package:renta_control/data/repositories/representative/representative_repository.dart';
import 'package:renta_control/data/repositories/tenant/tenant_repository.dart';
import 'package:renta_control/data/repositories/users/user_repository.dart';
import 'package:renta_control/firebase_options.dart';
import 'package:renta_control/presentation/blocs/auth/auth_bloc.dart';
import 'package:renta_control/presentation/blocs/auth/auth_event.dart';
import 'package:renta_control/presentation/blocs/auth/auth_state.dart';
import 'package:renta_control/presentation/blocs/contracts/contract_bloc.dart';
import 'package:renta_control/presentation/blocs/guarantor/guarantor_bloc.dart';
import 'package:renta_control/presentation/blocs/invoices/invoice_bloc.dart';
import 'package:renta_control/presentation/blocs/owners/owner_bloc.dart';
import 'package:renta_control/presentation/blocs/properties/property_bloc.dart';
import 'package:renta_control/presentation/blocs/representative/representative_bloc.dart';
import 'package:renta_control/presentation/blocs/tenant/tenant_bloc.dart';
import 'package:renta_control/presentation/blocs/user/user_bloc.dart';
import 'package:renta_control/presentation/pages/home_page.dart';
import 'package:renta_control/presentation/pages/login_page.dart';
import 'package:renta_control/presentation/pages/splash_page.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

//Configuración de la instancia de inyección de dependencias
final getIt = GetIt.instance;

void setupLocator() {
  //Registra todos los repositorios o servicios según sea necesario
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepository());
  getIt.registerLazySingleton<PropertyRepository>(() => PropertyRepository());
  getIt.registerLazySingleton<ContractRepository>(() => ContractRepository());
  getIt.registerLazySingleton<OwnerRepository>(() => OwnerRepository());
  getIt.registerLazySingleton<InvoiceRepository>(() => InvoiceRepository());
  getIt.registerLazySingleton<TenantRepository>(() => TenantRepository());
  getIt.registerLazySingleton<GuarantorRepository>(() => GuarantorRepository());
  getIt.registerLazySingleton<UserRepository>(() => UserRepository());
  getIt.registerLazySingleton<RepresentativeRepository>(
    () => RepresentativeRepository(),
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((value) async {
    await initializeDateFormatting('es');
    Intl.defaultLocale = 'es';
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    setupLocator();
    await dotenv.load(fileName: ".env");
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
        RepositoryProvider(create: (_) => getIt<InvoiceRepository>()),
        RepositoryProvider(create: (_) => getIt<TenantRepository>()),
        RepositoryProvider(create: (_) => getIt<GuarantorRepository>()),
        RepositoryProvider(create: (_) => getIt<UserRepository>()),
        RepositoryProvider(create: (_) => getIt<RepresentativeRepository>()),
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
          BlocProvider(
            create:
                (context) =>
                    InvoiceBloc(repository: context.read<InvoiceRepository>()),
          ),
          BlocProvider(
            create:
                (context) =>
                    TenantBloc(repository: context.read<TenantRepository>()),
          ),
          BlocProvider(
            create:
                (context) => GuarantorBloc(
                  repository: context.read<GuarantorRepository>(),
                ),
          ),
          BlocProvider(
            create:
                (context) =>
                    UserBloc(userRepository: context.read<UserRepository>()),
          ),
          BlocProvider(
            create:
                (context) => RepresentativeBloc(
                  repository: context.read<RepresentativeRepository>(),
                ),
          ),
        ],
        child: MaterialApp(
          title: 'Renta Control',
          theme: ThemeData(primarySwatch: Colors.blue),
          localizationsDelegates: const [
            GlobalMaterialLocalizations
                .delegate, // Proporciona textos y formatos de Material Design
            GlobalWidgetsLocalizations
                .delegate, // Proporciona textos genéricos de widgets
            GlobalCupertinoLocalizations
                .delegate, // Proporciona textos de Cupertino (iOS) si los usas
          ],
          supportedLocales: const [
            Locale('en', ''), // Soporte para inglés (idioma por defecto)
            Locale('es', ''), // Soporte para español
          ],
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
