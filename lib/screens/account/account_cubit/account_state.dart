part of 'account_cubit.dart';



class AccountState extends Equatable {
  final AccountStatus accountStatus;
  final String username;
  final String password;

  const AccountState({
    this.accountStatus = AccountStatus.initial,
    this.username = '',
    this.password = '',
  });

  AccountState copyWith({
    AccountStatus? accountStatus,
    String? username,
    String? password,
  }) {
    return AccountState(
      accountStatus: accountStatus ?? this.accountStatus,
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }

  @override
  List<Object?> get props => [accountStatus, username, password];
}

enum AccountStatus { initial, loading, loaded, logout, error }