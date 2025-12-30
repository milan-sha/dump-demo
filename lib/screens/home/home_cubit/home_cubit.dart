import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cart.dart';
import '../../products.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final List<Product> _initialProducts;

  HomeCubit(this._initialProducts) : super(HomeLoaded(
      allProducts: _initialProducts,
      filteredProducts: _initialProducts
  ));

  void filterProducts(String query) {
    if (state is HomeLoaded) {
      final currentLoaded = state as HomeLoaded;
      final filtered = currentLoaded.allProducts
          .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
          .toList();

      emit(HomeLoaded(
          allProducts: currentLoaded.allProducts,
          filteredProducts: filtered
      ));
    }
  }

  // New method to handle the "Upload" to cart logic
  void addToCart(Product product) {
    final existingIndex = cartItems.indexWhere((item) => item.name == product.name);

    if (existingIndex >= 0) {
      cartItems[existingIndex].quantity++;
    } else {
      cartItems.add(
        CartItem(
          name: product.name,
          image: product.assetPath,
          price: product.price,
          quantity: 1,
        ),
      );
    }
  }
}