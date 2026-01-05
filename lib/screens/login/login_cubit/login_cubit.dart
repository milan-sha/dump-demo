import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginState());

  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  Future<void> login(String email, String password) async {
    emit(state.copyWith(loginStatus: LoginStatus.loading, clearErrorMessage: true));
    try {
      final box = Hive.box('userBox');
      await box.put('username', email);
      await box.put('password', password);
      emit(state.copyWith(loginStatus: LoginStatus.success));
    } catch (e) {
      emit(state.copyWith(
        loginStatus: LoginStatus.error,
        errorMessage: 'Login failed: ${e.toString()}',
      ));
    }
  }
}