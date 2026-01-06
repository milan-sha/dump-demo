part of 'checkout_cubit.dart';



class CheckoutState extends Equatable {
  final CheckoutStatus checkoutStatus;
  final DateTime? startDateTime;
  final DateTime? endDateTime;
  final String? errorMessage;
  final String? name;
  final String? phone;
  final String? email;
  final String? address;
  final List<dynamic>? items;
  final double? total;
  final bool isSubmitted;

  const CheckoutState({
    this.checkoutStatus = CheckoutStatus.initial,
    this.startDateTime,
    this.endDateTime,
    this.errorMessage,
    this.name,
    this.phone,
    this.email,
    this.address,
    this.items,
    this.total,
    this.isSubmitted = false,
  });

  CheckoutState copyWith({
    CheckoutStatus? checkoutStatus,
    DateTime? startDateTime,
    DateTime? endDateTime,
    String? errorMessage,
    String? name,
    String? phone,
    String? email,
    String? address,
    List<dynamic>? items,
    double? total,
    bool? isSubmitted,
    bool clearStartDateTime = false,
    bool clearEndDateTime = false,
    bool clearErrorMessage = false,
  }) {
    return CheckoutState(
      checkoutStatus: checkoutStatus ?? this.checkoutStatus,
      startDateTime: clearStartDateTime ? null : (startDateTime ?? this.startDateTime),
      endDateTime: clearEndDateTime ? null : (endDateTime ?? this.endDateTime),
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      items: items ?? this.items,
      total: total ?? this.total,
      isSubmitted: isSubmitted ?? this.isSubmitted,
    );
  }

  @override
  List<Object?> get props => [
    checkoutStatus, startDateTime, endDateTime, errorMessage,
    name, phone, email, address, items, total, isSubmitted
  ];
}

enum CheckoutStatus { initial, processing, success, error }
