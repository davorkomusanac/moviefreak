import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'application/auth/auth_actions/auth_actions_cubit.dart';
import 'application/auth/auth_check/auth_check_cubit.dart';
import 'constants.dart';
import 'data/auth/auth_repository.dart';
import 'firebase_options.dart';
import 'presentation/pages/auth/splash/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => RepositoryProvider(
        create: (_) => AuthRepository(),
        child: MultiBlocProvider(
          providers: [
            BlocProvider<AuthActionsCubit>(
              create: (context) => AuthActionsCubit(
                authRepository: context.read<AuthRepository>(),
              ),
            ),
            BlocProvider<AuthCheckCubit>(
              create: (context) => AuthCheckCubit(
                authRepository: context.read<AuthRepository>(),
              ),
            ),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: AppStrings.appName,
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: const SplashPage(),
          ),
        ),
      );
}
