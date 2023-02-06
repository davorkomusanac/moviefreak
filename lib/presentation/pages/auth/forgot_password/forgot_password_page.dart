import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../application/auth/auth_actions/auth_actions_cubit.dart';
import '../../../../constants.dart';
import '../../widgets/input_text_field.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  AppStrings.forgotPasswordSuccessMessage,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
        },
        builder: (context, state) => Scaffold(
          appBar: AppBar(
            title: const Text(AppStrings.forgotPasswordTitle),
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
                        const SizedBox(height: 30),
                        InputTextField(
                          controller: _controller,
                          margin: const EdgeInsets.all(16),
                          hintText: AppStrings.forgotPasswordHintText,
                          prefixIcon: const Icon(
                            Icons.email,
                          ),
                        ),
                        const SizedBox(height: 15),
                        ElevatedButton(
                          onPressed: () {
                            context.read<AuthActionsCubit>().resetPasswordPressed(
                                  email: _controller.text.trim(),
                                );
                          },
                          child: const Text(AppStrings.singInButtonText),
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
