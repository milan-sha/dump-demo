import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import '../../../core/network/api_service.dart';
import '../../../models/product.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  Future<void> loadProducts({int limit = 40, int skip = 0}) async {
    emit(state.copyWith(homeStatus: HomeStatus.loading, clearErrorMessage: true));

    try {
      final productsResponse = await ApiService.getProducts(limit: limit, skip: skip);

      emit(state.copyWith(
        homeStatus: HomeStatus.loaded,
        allProducts: productsResponse.products,
        filteredProducts: productsResponse.products,
        totalProducts: productsResponse.total ?? 0,
        currentPage: skip ~/ limit + 1,
        totalPages: (productsResponse.total ?? 0 / limit).ceil(),
      ));
    } on ApiException catch (e) {
      if (kDebugMode) print('API Error loading products: ${e.message}');
      emit(state.copyWith(
        homeStatus: HomeStatus.error,
        errorMessage: e.message,
      ));
    } catch (e) {
      if (kDebugMode) print('Error loading products: $e');
      emit(state.copyWith(
        homeStatus: HomeStatus.error,
        errorMessage: 'Failed to load products: ${e.toString()}',
      ));
    }
  }

  /// ✅ FIXED: Safe nullable return type handling
  Product? getProductById(int id) {
    try {
      return state.allProducts.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;  // ✅ SAFE: Returns null when product not found
    }
  }

  void filterProducts(String query) {
    if (query.isEmpty) {
      emit(state.copyWith(filteredProducts: state.allProducts));
    } else {
      final filtered = state.allProducts
          .where((p) => p.title.toLowerCase().contains(query.toLowerCase()) ||
          p.description.toLowerCase().contains(query.toLowerCase()) ||
          p.brand.toLowerCase().contains(query.toLowerCase()))
          .toList();
      emit(state.copyWith(filteredProducts: filtered));
    }
  }

  void clearFilter() {
    emit(state.copyWith(filteredProducts: state.allProducts));
  }

  void refresh() {
    loadProducts();
  }
}
