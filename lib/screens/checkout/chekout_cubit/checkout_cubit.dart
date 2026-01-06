import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit() : super(const CheckoutState());

  DateTime? get startDateTime => state.startDateTime;
  DateTime? get endDateTime => state.endDateTime;

  void setStartDateTime(DateTime dateTime) {
    emit(state.copyWith(
      startDateTime: dateTime,
      clearEndDateTime: true,
    ));
  }

  void setEndDateTime(DateTime dateTime) {
    if (state.startDateTime == null) {
      emit(state.copyWith(
        checkoutStatus: CheckoutStatus.error,
        errorMessage: 'Please select a Start Time first.',
      ));
      return;
    }

    final duration = dateTime.difference(state.startDateTime!);
    if (dateTime.isBefore(state.startDateTime!)) {
      emit(state.copyWith(
        checkoutStatus: CheckoutStatus.error,
        errorMessage: 'End time cannot be before Start time.',
      ));
    } else if (duration.inHours >= 24) {
      emit(state.copyWith(
        checkoutStatus: CheckoutStatus.error,
        errorMessage: 'Delivery window cannot exceed 24 hours.',
      ));
    } else {
      emit(state.copyWith(endDateTime: dateTime, clearErrorMessage: true));
    }
  }

  void saveDetails({
    required String name,
    required String email,
    required String phone,
    required String address,
    required List<dynamic> items,
    required double total,
  }) {
    emit(state.copyWith(
      name: name,
      email: email,
      phone: phone,
      address: address,
      items: items,
      total: total,
      clearErrorMessage: true,
    ));
  }

  void processCheckout() {
    if (state.startDateTime == null || state.endDateTime == null) {
      emit(state.copyWith(
        checkoutStatus: CheckoutStatus.error,
        errorMessage: 'Please select your delivery window.',
      ));
      return;
    }

    emit(state.copyWith(checkoutStatus: CheckoutStatus.processing, clearErrorMessage: true));
    Future.delayed(const Duration(seconds: 1), () {
      emit(state.copyWith(checkoutStatus: CheckoutStatus.success));
    });
  }

  void reset() {
    emit(const CheckoutState());
  }
}