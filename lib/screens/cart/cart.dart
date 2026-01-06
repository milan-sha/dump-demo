import 'package:equatable/equatable.dart';

class CartItem extends Equatable {
  final int productId;
  final String name;
  final double price;
  final int quantity;

  const CartItem({
    required this.productId,
    required this.name,
    required this.price,
    this.quantity = 1,
  });

  CartItem copyWith({int? quantity}) {
    return CartItem(
      productId: productId,
      name: name,
      price: price,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [productId, name, price, quantity];
}