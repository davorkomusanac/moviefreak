import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/auth/auth_actions/auth_actions_cubit.dart';
import '../auth/splash/splash_page.dart';
import '../widgets/title_label.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocConsumer<AuthActionsCubit, AuthActionsState>(
        listener: (context, state) {
          if (state.status == AuthActionsStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          if (state.status == AuthActionsStatus.success) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const SplashPage(),
              ),
            );
          }
        },
        builder: (context, state) => Scaffold(
          appBar: AppBar(
            title: const TitleLabel(
              color: Colors.white,
            ),
          ),
          body: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      children: [
                        const SizedBox(height: 350),
                        const Text(
                          'You are Signed In',
                          style: TextStyle(
                            fontSize: 39,
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () {
                            context.read<AuthActionsCubit>().signOutPressed();
                          },
                          child: const Text('Sign Out'),
                        ),
                      ],
                    ),
                    if (state.status == AuthActionsStatus.loading)
                      Opacity(
                        opacity: 0.8,
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: const ModalBarrier(
                            dismissible: false,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    if (state.status == AuthActionsStatus.loading)
                      Container(
                        padding: const EdgeInsets.all(45),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const CircularProgressIndicator(),
                      ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
}
