abstract class LoginState {}

class LoginInitial extends LoginState {
  final bool isPasswordVisible;
  LoginInitial({this.isPasswordVisible = false});
}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginFailure extends LoginState {
  final String message;
  LoginFailure(this.message);
}