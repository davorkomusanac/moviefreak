import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/auth/auth_repository.dart';

part 'auth_actions_state.dart';

class AuthActionsCubit extends Cubit<AuthActionsState> {
  final AuthRepository authRepository;

  AuthActionsCubit({required this.authRepository}) : super(const AuthActionsState());

  Future<void> registerPressed({
    required String fullName,
    required String email,
    required String password,
  }) async {
    if (fullName.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
      if (password.length > 5) {
        emit(
          state.copyWith(
            status: AuthActionsStatus.loading,
          ),
        );

        try {
          await authRepository.registerUserWithEmailAndPassword(
            email: email,
            password: password,
            fullName: fullName,
          );

          emit(
            state.copyWith(
              status: AuthActionsStatus.success,
            ),
          );
        } catch (e) {
          log(e.toString());
          emit(
            state.copyWith(
              errorMessage: e.toString(),
              status: AuthActionsStatus.error,
            ),
          );
        }
      } else {
        emit(
          state.copyWith(
            errorMessage: 'Error! Your password must be at least 6 characters long',
            status: AuthActionsStatus.error,
          ),
        );
      }
    } else {
      emit(
        state.copyWith(
          errorMessage: 'Error! All fields must be filled',
          status: AuthActionsStatus.error,
        ),
      );
    }
  }

  Future<void> signOutPressed() async {
    emit(
      state.copyWith(
        status: AuthActionsStatus.loading,
      ),
    );

    try {
      await authRepository.signOut();
      emit(
        state.copyWith(
          status: AuthActionsStatus.success,
        ),
      );
    } catch (e) {
      log(e.toString());
      emit(
        state.copyWith(
          errorMessage: e.toString(),
          status: AuthActionsStatus.error,
        ),
      );
    }
  }

  Future<void> signInWithEmailAndPasswordPressed({
    required String email,
    required String password,
  }) async {
    if (email.isNotEmpty && password.isNotEmpty) {
      if (password.length > 5) {
        emit(
          state.copyWith(
            status: AuthActionsStatus.loading,
          ),
        );

        try {
          await authRepository.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
          emit(
            state.copyWith(
              status: AuthActionsStatus.success,
            ),
          );
        } catch (e) {
          log(e.toString());
          emit(
            state.copyWith(
              errorMessage: e.toString(),
              status: AuthActionsStatus.error,
            ),
          );
        }
      } else {
        emit(
          state.copyWith(
            errorMessage: 'Error! Your password must be at least 6 characters long',
            status: AuthActionsStatus.error,
          ),
        );
      }
    } else {
      emit(
        state.copyWith(
          errorMessage: 'Error! All fields must be filled',
          status: AuthActionsStatus.error,
        ),
      );
    }
  }

  Future<void> signInWithGooglePressed() async {
    emit(
      state.copyWith(
        status: AuthActionsStatus.loading,
      ),
    );

    try {
      await authRepository.signInWithGoogle();
      emit(
        state.copyWith(
          status: AuthActionsStatus.success,
        ),
      );
    } catch (e) {
      log(e.toString());
      emit(
        state.copyWith(
          errorMessage: e.toString(),
          status: AuthActionsStatus.error,
        ),
      );
    }
  }

  Future<void> resetPasswordPressed({required String email}) async {
    emit(
      state.copyWith(
        status: AuthActionsStatus.loading,
      ),
    );

    try {
      await authRepository.resetPassword(email: email);
      emit(
        state.copyWith(
          status: AuthActionsStatus.success,
        ),
      );
    } catch (e) {
      log(e.toString());
      emit(
        state.copyWith(
          errorMessage: e.toString(),
          status: AuthActionsStatus.error,
        ),
      );
    }
  }

  Future<void> deleteAccountPressed({String? password}) async {
    emit(
      state.copyWith(
        status: AuthActionsStatus.loading,
      ),
    );

    try {
      await authRepository.deleteUser(password: password);
      emit(
        state.copyWith(
          status: AuthActionsStatus.success,
        ),
      );
    } catch (e) {
      log(e.toString());
      emit(
        state.copyWith(
          errorMessage: e.toString(),
          status: AuthActionsStatus.error,
        ),
      );
    }
  }

  void getAuthProvider() {
    String provider = authRepository.getAuthProvider() ?? '';
    emit(
      state.copyWith(
        isRegisteredWithEmailAndPassword: provider == 'password',
      ),
    );
  }
}
