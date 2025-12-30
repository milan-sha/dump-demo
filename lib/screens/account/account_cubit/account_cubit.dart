// account_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce/hive_ce.dart';
import 'account_state.dart';

class AccountCubit extends Cubit<AccountState> {
  AccountCubit() : super(AccountInitial());

  Box? _userBox;

  Future<void> loadUserData() async {
    try {
      _userBox ??= Hive.box('userBox');
      emit(AccountLoading());

      String username = _userBox!.get('username', defaultValue: 'Guest') as String;
      String password = _userBox!.get('password', defaultValue: '****') as String;

      emit(AccountLoaded(username: username, password: password));
    } catch (e) {
      emit(AccountInitial());
    }
  }

  Future<void> logout() async {
    try {
      if (_userBox != null) {
        await _userBox!.clear();
      }
      emit(AccountLogout());
    } catch (e) {
      emit(AccountInitial());
    }
  }
}
