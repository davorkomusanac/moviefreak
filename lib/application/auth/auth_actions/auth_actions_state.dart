part of 'auth_actions_cubit.dart';

enum AuthActionsStatus {
  initial,
  loading,
  success,
  error,
}

class AuthActionsState extends Equatable {
  const AuthActionsState({
    this.status = AuthActionsStatus.initial,
    this.fullName = '',
    this.email = '',
    this.password = '',
    this.errorMessage = '',
    this.isRegisteredWithEmailAndPassword = false,
  });

  final AuthActionsStatus status;
  final String fullName;
  final String email;
  final String password;
  final String errorMessage;
  final bool isRegisteredWithEmailAndPassword;

  AuthActionsState copyWith({
    AuthActionsStatus? status,
    String? fullName,
    String? email,
    String? password,
    String? errorMessage,
    bool? isRegisteredWithEmailAndPassword,
  }) =>
      AuthActionsState(
        status: status ?? this.status,
        fullName: fullName ?? this.fullName,
        email: email ?? this.email,
        password: password ?? this.password,
        errorMessage: errorMessage ?? this.errorMessage,
        isRegisteredWithEmailAndPassword: isRegisteredWithEmailAndPassword ?? this.isRegisteredWithEmailAndPassword,
      );

  @override
  List<Object> get props => [
        status,
        fullName,
        email,
        password,
        errorMessage,
        isRegisteredWithEmailAndPassword,
      ];
}
