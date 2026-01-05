import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import '../../../models/hive_products.dart';
import '../../../service/storage _service.dart';

part 'product_category_by___state.dart';

class ProductListCubit extends Cubit<ProductListState> with StorageServiceMixin {
  ProductListCubit() : super(const ProductListState());

  void loadProductsByCategory(String categoryName) {
    emit(state.copyWith(productListStatus: ProductListStatus.loading, clearErrorMessage: true));
    try {
      final box = Hive.box<Product>('products');
      final categoryProducts = box.values
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