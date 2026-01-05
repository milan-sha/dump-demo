part of 'cart_cubit.dart';


class CartState extends Equatable {
  final List<CartItem> items;
  final double subtotal;

  const CartState({
    this.items = const [],
    this.subtotal = 0.0,
  });

  CartState copyWith({
    List<CartItem>? items,
    double? subtotal,
  }) {
    return CartState(
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
    );
  }

  @override
  List<Object?> get props => [items, subtotal];
}