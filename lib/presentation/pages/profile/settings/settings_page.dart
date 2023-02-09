import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../application/auth/auth_actions/auth_actions_cubit.dart';
import '../../auth/splash/splash_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text("Settings"),
        ),
        body: BlocConsumer<AuthActionsCubit, AuthActionsState>(
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
          builder: (context, state) => Column(
            children: [
              const Spacer(),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => const LogOutDialog(),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.0),
                    child: Text("Log Out"),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => const DeleteAccountDialog(),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Delete Account"),
                  ),
                ),
              ),
              const Spacer(flex: 6),
            ],
          ),
        ),
      );
}

class LogOutDialog extends StatefulWidget {
  const LogOutDialog({Key? key}) : super(key: key);

  @override
  State<LogOutDialog> createState() => _LogOutDialogState();
}

class _LogOutDialogState extends State<LogOutDialog> {
  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text("Confirm if you want to log out of your account"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () {
              context.read<AuthActionsCubit>().signOutPressed();
              Navigator.of(context, rootNavigator: true).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const SplashPage(),
                ),
              );
            },
            child: const Text("Yes"),
          ),
        ],
      );
}

class DeleteAccountDialog extends StatefulWidget {
  const DeleteAccountDialog({Key? key}) : super(key: key);

  @override
  State<DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<DeleteAccountDialog> {
  @override
  void initState() {
    super.initState();
    context.read<AuthActionsCubit>().getAuthProvider();
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<AuthActionsCubit, AuthActionsState>(
        builder: (context, state) => AlertDialog(
          title: const Text("Are you sure you want to delete your account? This action is irreversible."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                if (state.isRegisteredWithEmailAndPassword) {
                  showDialog(
                    context: context,
                    builder: (context) => const ConfirmPasswordDialog(),
                  );
                } else {
                  context.read<AuthActionsCubit>().deleteAccountPressed();
                  Navigator.of(context, rootNavigator: true).pop();
                }
              },
              child: const Text("Yes"),
            ),
          ],
        ),
      );
}

class ConfirmPasswordDialog extends StatefulWidget {
  const ConfirmPasswordDialog({Key? key}) : super(key: key);

  @override
  State<ConfirmPasswordDialog> createState() => _ConfirmPasswordDialogState();
}

class _ConfirmPasswordDialogState extends State<ConfirmPasswordDialog> {
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
  Widget build(BuildContext context) => AlertDialog(
        title: const Text("Confirm your password if you wish to delete your account"),
        content: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: TextField(
            obscureText: true,
            controller: _controller,
            maxLines: 1,
            decoration: const InputDecoration(
              hintText: 'Type your password here...',
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
              Navigator.of(context, rootNavigator: true).pop();
            },
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () {
              context.read<AuthActionsCubit>().deleteAccountPressed(
                    password: _controller.text.trim(),
                  );
              Navigator.of(context, rootNavigator: true).pop();
              Navigator.of(context, rootNavigator: true).pop();
            },
            child: const Text("Yes"),
          ),
        ],
      );
}
