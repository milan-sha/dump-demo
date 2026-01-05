import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/hive_products.dart';
import '../../../service/storage _service.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> with StorageServiceMixin {
  HomeCubit() : super(const HomeState());

  void loadProducts() {
    emit(state.copyWith(homeStatus: HomeStatus.loading, clearErrorMessage: true));
    try {
      final products = getHiveProducts();
      emit(state.copyWith(
        homeStatus: HomeStatus.loaded,
        allProducts: products,
        filteredProducts: products,
      ));
    } catch (e) {
      emit(state.copyWith(
        homeStatus: HomeStatus.error,
        errorMessage: "Failed to load products: ${e.toString()}",
      ));
    }
  }

  void filterProducts(String query) {
    if (state.homeStatus == HomeStatus.loaded) {
      if (query.isEmpty) {
        emit(state.copyWith(filteredProducts: state.allProducts));
      } else {
        final filtered = state.allProducts
            .where((p) => p.title.toLowerCase().contains(query.toLowerCase()))
            .toList();
        emit(state.copyWith(filteredProducts: filtered));
      }
    }
  }
}