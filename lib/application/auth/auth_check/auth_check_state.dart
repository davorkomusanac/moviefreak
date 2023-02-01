part of 'auth_check_cubit.dart';

enum AuthCheckStatus {
  initial,
  authenticated,
  unauthenticated,
  error,
}

class AuthCheckState extends Equatable {
  const AuthCheckState({
    this.status = AuthCheckStatus.initial,
    this.user,
    this.errorMessage = '',
  });

  final AuthCheckStatus status;
  final User? user;
  final String errorMessage;

  AuthCheckState copyWith({
    AuthCheckStatus? status,
    User? user,
    String? errorMessage,
  }) =>
      AuthCheckState(
        status: status ?? this.status,
        user: user ?? this.user,
        errorMessage: errorMessage ?? this.errorMessage,
      );

  @override
  List<Object> get props => [
        status,
        user ?? '',
        errorMessage,
      ];
}
