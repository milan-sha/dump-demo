import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/network/api_service.dart';
import '../../../models/product.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  Future<void> loadProducts() async {
    emit(state.copyWith(homeStatus: HomeStatus.loading, clearErrorMessage: true));
    try {
      final products = await ApiService.getProducts();

      emit(state.copyWith(
        homeStatus: HomeStatus.loaded,
        allProducts: products,
        filteredProducts: products,
      ));
    } catch (e) {
      emit(state.copyWith(
        homeStatus: HomeStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Product? getProductById(int id) {
    return state.allProducts.where((p) => p.id == id).firstOrNull;
  }

  void filterProducts(String query) {
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