abstract class CheckoutState {}

class CheckoutInitial extends CheckoutState {
  final DateTime? startDateTime;
  final DateTime? endDateTime;

  CheckoutInitial({this.startDateTime, this.endDateTime});
}

class CheckoutProcessing extends CheckoutState {}

class CheckoutSuccess extends CheckoutState {}

class CheckoutFailure extends CheckoutState {
  final String message;
  CheckoutFailure(this.message);
}