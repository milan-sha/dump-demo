import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import '../../../models/product.dart';
import '../../../core/network/api_service.dart';

part 'product_list_state.dart';  // ✅ CORRECT: matches filename exactly

class ProductListCubit extends Cubit<ProductListState> {
  ProductListCubit() : super(const ProductListState());

  Future<void> loadProductsByCategory(String categoryName) async {
    emit(state.copyWith(
      productListStatus: ProductListStatus.loading,
      clearErrorMessage: true,
      currentCategory: categoryName,
    ));

    try {
      final categoryProducts = await ApiService.getProductsByCategory(categoryName);

      emit(state.copyWith(
        productListStatus: ProductListStatus.loaded,
        products: categoryProducts.products,
        totalProducts: categoryProducts.total ?? 0,
        currentCategory: categoryName,
      ));
    } on ApiException catch (e) {
      if (kDebugMode) print('API Error: ${e.message}');
      emit(state.copyWith(
        productListStatus: ProductListStatus.error,
        errorMessage: e.message,
        currentCategory: categoryName,
        totalProducts: 0,
      ));
    } catch (e) {
      if (kDebugMode) print('Error: $e');
      emit(state.copyWith(
        productListStatus: ProductListStatus.error,
        errorMessage: 'Failed to load: ${e.toString()}',
        currentCategory: categoryName,
        totalProducts: 0,
      ));
    }
  }

  Future<void> refresh() async {
    final category = state.currentCategory;
    if (category != null) await loadProductsByCategory(category);
  }

  void clearProducts() {
    emit(state.copyWith(
      productListStatus: ProductListStatus.initial,
      products: [],
      currentCategory: null,
      totalProducts: 0,
    ));
  }
}
