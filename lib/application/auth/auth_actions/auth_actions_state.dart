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
  });

  final AuthActionsStatus status;
  final String fullName;
  final String email;
  final String password;
  final String errorMessage;

  AuthActionsState copyWith({
    AuthActionsStatus? status,
    String? fullName,
    String? email,
    String? password,
    String? errorMessage,
  }) =>
      AuthActionsState(
        status: status ?? this.status,
        fullName: fullName ?? this.fullName,
        email: email ?? this.email,
        password: password ?? this.password,
        errorMessage: errorMessage ?? this.errorMessage,
      );

  @override
  List<Object> get props => [
        status,
        fullName,
        email,
        password,
        errorMessage,
      ];
}
