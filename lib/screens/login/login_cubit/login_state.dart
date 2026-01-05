part of 'login_cubit.dart';

class LoginState extends Equatable {
  final LoginStatus loginStatus;
  final bool isPasswordVisible;
  final String? errorMessage;

  const LoginState({
    this.loginStatus = LoginStatus.initial,
    this.isPasswordVisible = false,
    this.errorMessage,
  });

  LoginState copyWith({
    LoginStatus? loginStatus,
    bool? isPasswordVisible,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return LoginState(
      loginStatus: loginStatus ?? this.loginStatus,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [loginStatus, isPasswordVisible, errorMessage];
}

enum LoginStatus { initial, loading, success, error }