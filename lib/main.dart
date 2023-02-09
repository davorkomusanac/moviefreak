import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'application/auth/auth_actions/auth_actions_cubit.dart';
import 'application/auth/auth_check/auth_check_cubit.dart';
import 'application/movies/movie_details/movie_details_cubit.dart';
import 'application/movies/movie_search/movie_search_cubit.dart';
import 'application/movies/popular_movies/popular_movies_cubit.dart';
import 'application/user/add_to_watchlist_or_watched/add_to_watchlist_or_watched_cubit.dart';
import 'application/user/user_watchlist_and_watched/user_watchlist_and_watched_cubit.dart';
import 'constants.dart';
import 'data/auth/auth_repository.dart';
import 'data/firestore/repository/firestore_repository.dart';
import 'data/movies/repository/movie_repository.dart';
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
  Widget build(BuildContext context) => MultiRepositoryProvider(
        providers: [
          RepositoryProvider(
            create: (_) => AuthRepository(),
          ),
          RepositoryProvider(
            create: (_) => MovieRepository(http.Client()),
          ),
          RepositoryProvider(
            create: (_) => FirestoreRepository(),
          ),
        ],
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
            BlocProvider<MovieSearchCubit>(
              create: (context) => MovieSearchCubit(
                movieRepository: context.read<MovieRepository>(),
              ),
            ),
            BlocProvider<PopularMoviesCubit>(
              create: (context) => PopularMoviesCubit(
                movieRepository: context.read<MovieRepository>(),
              ),
            ),
            BlocProvider<MovieDetailsCubit>(
              create: (context) => MovieDetailsCubit(
                movieRepository: context.read<MovieRepository>(),
              ),
            ),
            BlocProvider<AddToWatchlistOrWatchedCubit>(
              create: (context) => AddToWatchlistOrWatchedCubit(
                firestoreRepository: context.read<FirestoreRepository>(),
              ),
            ),
            BlocProvider<UserWatchlistAndWatchedCubit>(
              create: (context) => UserWatchlistAndWatchedCubit(
                firestoreRepository: context.read<FirestoreRepository>(),
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
