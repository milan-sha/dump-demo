// account_state.dart
abstract class AccountState {}

class AccountInitial extends AccountState {}

class AccountLoading extends AccountState {}

class AccountLoaded extends AccountState {
  final String username;
  final String password;

  AccountLoaded({required this.username, required this.password});
}

class AccountLogout extends AccountState {}