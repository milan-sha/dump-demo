import '../cart.dart'; // Import where your CartItem class is defined

abstract class CartState {}

class CartInitial extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> items;
  final double subtotal;
  CartLoaded({required this.items, required this.subtotal});
}