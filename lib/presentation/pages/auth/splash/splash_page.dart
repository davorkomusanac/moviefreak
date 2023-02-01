import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../application/auth/auth_check/auth_check_cubit.dart';
import '../../home/home_page.dart';
import '../../widgets/title_label.dart';
import '../login/login_page.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocListener<AuthCheckCubit, AuthCheckState>(
        listener: (context, state) {
          switch (state.status) {
            case AuthCheckStatus.initial:
              {
                break;
              }
            case AuthCheckStatus.error:
              {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.errorMessage,
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => const LoginPage(),
                  ),
                );
                break;
              }
            case AuthCheckStatus.unauthenticated:
              {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => const LoginPage(),
                  ),
                );
                break;
              }
            case AuthCheckStatus.authenticated:
              {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => const HomePage(),
                  ),
                );
                break;
              }
          }
        },
        child: Scaffold(
          body: SafeArea(
            child: Center(
              child: BlocBuilder<AuthCheckCubit, AuthCheckState>(
                builder: (context, state) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const TitleLabel(),
                    const SizedBox(
                      height: 15,
                    ),
                    const CircularProgressIndicator(),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      child: const Text('REMOVE ME LATER'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
