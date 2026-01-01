import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../service/storage _service.dart';// Ensure no spaces in filename
import '../../../models/hive_products.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> with StorageServiceMixin {
  HomeCubit() : super(HomeLoading());

  void loadProducts() {
    try {
      final products = getHiveProducts();
      emit(HomeLoaded(allProducts: products, filteredProducts: products));
    } catch (e) {
      emit(HomeError("Failed to load products: ${e.toString()}"));
    }
  }

  void filterProducts(String query) {
    if (state is HomeLoaded) {
      final current = state as HomeLoaded;
      if (query.isEmpty) {
        emit(HomeLoaded(allProducts: current.allProducts, filteredProducts: current.allProducts));
      } else {
        final filtered = current.allProducts
            .where((p) => p.title.toLowerCase().contains(query.toLowerCase()))
            .toList();
        emit(HomeLoaded(allProducts: current.allProducts, filteredProducts: filtered));
      }
    }
  }
}