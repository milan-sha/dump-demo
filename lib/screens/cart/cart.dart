import 'package:equatable/equatable.dart';

class CartItem extends Equatable {
  final String name;
  final double price;
  final int quantity;

  const CartItem({
    required this.name,
    required this.price,
    this.quantity = 1,
  });

  CartItem copyWith({int? quantity}) {
    return CartItem(
      name: name,
      price: price,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [name, price, quantity];
}