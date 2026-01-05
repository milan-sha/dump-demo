import 'package:flutter_bloc/flutter_bloc.dart';
import 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit() : super(CheckoutInitial());

  DateTime? _startDateTime;
  DateTime? _endDateTime;

  DateTime? get startDateTime => _startDateTime;
  DateTime? get endDateTime => _endDateTime;

  void setStartDateTime(DateTime dateTime) {
    _startDateTime = dateTime;
    _endDateTime = null;
    emit(CheckoutInitial(startDateTime: _startDateTime, endDateTime: _endDateTime));
  }

  void setEndDateTime(DateTime dateTime) {
    if (_startDateTime == null) {
      emit(CheckoutFailure('Please select a Start Time first.'));
      return;
    }

    final duration = dateTime.difference(_startDateTime!);
    if (dateTime.isBefore(_startDateTime!)) {
      emit(CheckoutFailure('End time cannot be before Start time.'));
    } else if (duration.inHours >= 24) {
      emit(CheckoutFailure('Delivery window cannot exceed 24 hours.'));
    } else {
      _endDateTime = dateTime;
      emit(CheckoutInitial(startDateTime: _startDateTime, endDateTime: _endDateTime));
    }
  }

  void processCheckout() {
    if (_startDateTime == null || _endDateTime == null) {
      emit(CheckoutFailure('Please select your delivery window.'));
      return;
    }
    emit(CheckoutProcessing());
    Future.delayed(const Duration(seconds: 1), () {
      emit(CheckoutSuccess());
    });
  }

  void reset() {
    _startDateTime = null;
    _endDateTime = null;
    emit(CheckoutInitial());
  }
}