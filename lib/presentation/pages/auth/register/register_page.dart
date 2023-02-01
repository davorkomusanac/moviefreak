import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../application/auth/auth_actions/auth_actions_cubit.dart';
import '../../../../constants.dart';
import '../../widgets/input_text_field.dart';
import '../../widgets/title_label.dart';
import '../login/login_page.dart';
import '../splash/splash_page.dart';
import '../widgets/agree_terms_checkbox.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _fullNameController;
  bool isAgreed = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _fullNameController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
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
                        const SizedBox(height: 30),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            AppStrings.promoRegisterText,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        InputTextField(
                          controller: _fullNameController,
                          margin: const EdgeInsets.all(16),
                          hintText: AppStrings.fullNameHint,
                          prefixIcon: const Icon(
                            Icons.person,
                          ),
                        ),
                        InputTextField(
                          controller: _emailController,
                          margin: const EdgeInsets.all(16),
                          hintText: AppStrings.emailHint,
                          prefixIcon: const Icon(
                            Icons.email,
                          ),
                        ),
                        InputTextField(
                          controller: _passwordController,
                          margin: const EdgeInsets.all(16),
                          hintText: AppStrings.passwordHint,
                          obscureText: true,
                          prefixIcon: const Icon(
                            Icons.lock,
                          ),
                        ),
                        AgreeTermsCheckbox(
                          isAgreed: isAgreed,
                          onChanged: (bool? value) {
                            if (value != null) {
                              setState(() {
                                isAgreed = value;
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 15),
                        ElevatedButton(
                          onPressed: () {
                            !isAgreed
                                ? ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("You need to check the checkbox before continuing"),
                                      duration: Duration(seconds: 1),
                                    ),
                                  )
                                : context.read<AuthActionsCubit>().registerPressed(
                                      fullName: _fullNameController.text.trim(),
                                      email: _emailController.text.trim(),
                                      password: _passwordController.text.trim(),
                                    );
                          },
                          child: const Text(AppStrings.registerButtonText),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 16.0,
                          ),
                          child: Divider(thickness: 1),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            );
                          },
                          child: const Text(
                            AppStrings.callToLoginUpButtonText,
                            textAlign: TextAlign.center,
                          ),
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
