import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cart.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState());

  void addToCart(CartItem item) {
    final updatedItems = List<CartItem>.from(state.items);
    final index = updatedItems.indexWhere((i) => i.productId == item.productId);

    if (index >= 0) {
      updatedItems[index] = CartItem(
        productId: item.productId,
        name: item.name,
        price: item.price,
        quantity: updatedItems[index].quantity + 1,
      );
    } else {
      updatedItems.add(item);
    }

    emit(state.copyWith(
      items: updatedItems,
      subtotal: _calculateTotal(updatedItems),
    ));
  }

  void removeOneFromCart(CartItem item) {
    final updatedItems = List<CartItem>.from(state.items);
    final index = updatedItems.indexWhere((i) => i.productId == item.productId);

    if (index >= 0) {
      if (updatedItems[index].quantity > 1) {
        updatedItems[index] = CartItem(
          productId: item.productId,
          name: item.name,
          price: item.price,
          quantity: updatedItems[index].quantity - 1,
        );
      } else {
        updatedItems.removeAt(index);
      }
    }

    emit(state.copyWith(
      items: updatedItems,
      subtotal: _calculateTotal(updatedItems),
    ));
  }

  void clearCart() {
    emit(const CartState());
  }

  double _calculateTotal(List<CartItem> items) {
    return items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }
}