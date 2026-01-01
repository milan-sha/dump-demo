import 'package:flutter_bloc/flutter_bloc.dart';
import 'cart_state.dart';
import '../cart.dart'; // Ensure this contains your CartItem model

class CartCubit extends Cubit<CartState> {
  // Fix 1: Initial state must provide both named arguments
  CartCubit() : super(CartLoaded(items: [], subtotal: 0.0));

  void addToCart(CartItem item) {
    if (state is CartLoaded) {
      final current = state as CartLoaded;
      final updatedItems = List<CartItem>.from(current.items);

      final index = updatedItems.indexWhere((i) => i.name == item.name);
      if (index >= 0) {
        updatedItems[index] = CartItem(
          name: item.name,
          price: item.price,
          quantity: updatedItems[index].quantity + 1,
        );
      } else {
        updatedItems.add(item);
      }

      // Fix 2: Use named arguments and calculate subtotal
      emit(CartLoaded(
        items: updatedItems,
        subtotal: _calculateTotal(updatedItems),
      ));
    }
  }

  void removeOneFromCart(CartItem item) {
    if (state is CartLoaded) {
      final current = state as CartLoaded;
      List<CartItem> updatedItems = List<CartItem>.from(current.items);

      final index = updatedItems.indexWhere((i) => i.name == item.name);
      if (index >= 0) {
        if (updatedItems[index].quantity > 1) {
          updatedItems[index] = CartItem(
            name: item.name,
            price: item.price,
            quantity: updatedItems[index].quantity - 1,
          );
        } else {
          updatedItems.removeAt(index);
        }
      }

      emit(CartLoaded(
        items: updatedItems,
        subtotal: _calculateTotal(updatedItems),
      ));
    }
  }

  // Fix 3: Clear cart with required names
  void clearCart() => emit(CartLoaded(items: [], subtotal: 0.0));

  // Helper function to keep subtotal accurate
  double _calculateTotal(List<CartItem> items) {
    return items.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }
}