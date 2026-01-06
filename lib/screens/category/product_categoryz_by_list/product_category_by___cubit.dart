import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/product.dart';
import '../../../core/network/api_service.dart';

part 'product_category_by___state.dart';

class ProductListCubit extends Cubit<ProductListState> {
  ProductListCubit() : super(const ProductListState());

  Future<void> loadProductsByCategory(String categoryName) async {
    emit(state.copyWith(productListStatus: ProductListStatus.loading, clearErrorMessage: true));
    try {
      // Fetch all products from API and filter by category
      final allProducts = await ApiService.getProducts();
      final categoryProducts = allProducts
          .where((p) => p.category.toLowerCase() == categoryName.toLowerCase())
          .toList();
      emit(state.copyWith(
        productListStatus: ProductListStatus.loaded,
        products: categoryProducts,
      ));
    } catch (e) {
      emit(state.copyWith(
        productListStatus: ProductListStatus.error,
        errorMessage: 'Failed to load products: ${e.toString()}',
      ));
    }
  }
}