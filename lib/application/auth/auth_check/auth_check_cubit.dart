import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/auth/auth_repository.dart';

part 'auth_check_state.dart';

class AuthCheckCubit extends Cubit<AuthCheckState> {
  final AuthRepository authRepository;
  StreamSubscription<User?>? _stream;

  @override
  Future<void> close() {
    _stream?.cancel();
    return super.close();
  }

  AuthCheckCubit({required this.authRepository}) : super(const AuthCheckState()) {
    _stream?.cancel();
    _stream = authRepository.userAuthState().listen(
      (user) => userAuthChanged(user),
      onError: (e) {
        emit(
          state.copyWith(
            status: AuthCheckStatus.error,
            errorMessage: e.toString(),
          ),
        );
      },
    );
  }

  void userAuthChanged(User? user) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (user == null) {
      emit(
        state.copyWith(
          status: AuthCheckStatus.unauthenticated,
          user: user,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: AuthCheckStatus.authenticated,
          user: user,
        ),
      );
    }
  }
}
