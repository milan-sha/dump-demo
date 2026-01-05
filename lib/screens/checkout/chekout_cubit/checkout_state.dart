part of 'checkout_cubit.dart';

class CheckoutState extends Equatable {
  final CheckoutStatus checkoutStatus;
  final DateTime? startDateTime;
  final DateTime? endDateTime;
  final String? errorMessage;

  const CheckoutState({
    this.checkoutStatus = CheckoutStatus.initial,
    this.startDateTime,
    this.endDateTime,
    this.errorMessage,
  });

  CheckoutState copyWith({
    CheckoutStatus? checkoutStatus,
    DateTime? startDateTime,
    DateTime? endDateTime,
    String? errorMessage,
    bool clearStartDateTime = false,
    bool clearEndDateTime = false,
    bool clearErrorMessage = false,
  }) {
    return CheckoutState(
      checkoutStatus: checkoutStatus ?? this.checkoutStatus,
      startDateTime: clearStartDateTime ? null : (startDateTime ?? this.startDateTime),
      endDateTime: clearEndDateTime ? null : (endDateTime ?? this.endDateTime),
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [checkoutStatus, startDateTime, endDateTime, errorMessage];
}

enum CheckoutStatus { initial, processing, success, error }