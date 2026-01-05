import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

part 'account_state.dart';

class AccountCubit extends Cubit<AccountState> {
  AccountCubit() : super(const AccountState());

  Box? _userBox;

  Future<void> loadUserData() async {
    try {
      _userBox ??= Hive.box('userBox');
      emit(state.copyWith(accountStatus: AccountStatus.loading));

      String username = _userBox!.get('username', defaultValue: 'Guest') as String;
      String password = _userBox!.get('password', defaultValue: '****') as String;

      emit(state.copyWith(
        accountStatus: AccountStatus.loaded,
        username: username,
        password: password,
      ));
    } catch (e) {
      emit(const AccountState());
    }
  }

  Future<void> logout() async {
    try {
      if (_userBox != null) {
        await _userBox!.clear();
      }
      emit(state.copyWith(accountStatus: AccountStatus.logout));
    } catch (e) {
      emit(const AccountState());
    }
  }
}