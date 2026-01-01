import 'package:flutter_bloc/flutter_bloc.dart';
// Ensure the path and filename (no spaces) match your project structure
import '../../../service/storage _service.dart';
import '../../../models/hive_products.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> with StorageServiceMixin {
  // Pass an empty list initially if your HomeLoading state requires it,
  // or stick with HomeLoading() if it's a simple state.
  HomeCubit() : super(HomeLoading());

  void loadProducts() {
    try {
      // Fetch products from the Hive box via the Mixin
      final products = getHiveProducts();

      if (products.isEmpty) {
        // Optional: you could emit a HomeEmpty state here
        emit(HomeLoaded(allProducts: [], filteredProducts: []));
      } else {
        emit(HomeLoaded(allProducts: products, filteredProducts: products));
      }
    } catch (e) {
      // It's good practice to handle potential storage errors
      emit(HomeError("Failed to load products from local storage"));
    }
  }

  void filterProducts(String query) {
    if (state is HomeLoaded) {
      final current = state as HomeLoaded;

      if (query.isEmpty) {
        emit(HomeLoaded(
          allProducts: current.allProducts,
          filteredProducts: current.allProducts,
        ));
        return;
      }

      final filtered = current.allProducts
          .where((p) => p.title.toLowerCase().contains(query.toLowerCase()))
          .toList();

      emit(HomeLoaded(
        allProducts: current.allProducts,
        filteredProducts: filtered,
      ));
    }
  }
}