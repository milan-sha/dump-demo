import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  bool _isPasswordVisible = false;
  bool get isPasswordVisible => _isPasswordVisible;

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    emit(LoginInitial(isPasswordVisible: _isPasswordVisible));
  }

  Future<void> login(String email, String password) async {
    emit(LoginLoading());
    try {
      final box = Hive.box('userBox');
      await box.put('username', email);
      await box.put('password', password);
      emit(LoginSuccess());
    } catch (e) {
      emit(LoginFailure('Login failed: ${e.toString()}'));
    }
  }
}