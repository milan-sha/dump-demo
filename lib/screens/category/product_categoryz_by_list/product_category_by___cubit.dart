import 'package:dump/screens/category/product_categoryz_by_list/product_category_by___state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import '../../../models/hive_products.dart';
import '../../../service/storage _service.dart';


class ProductListCubit extends Cubit<ProductListState> with StorageServiceMixin {
  ProductListCubit() : super(ProductListInitial());

  void loadProductsByCategory(String categoryName) {
    emit(ProductListLoading());
    try {
      final box = Hive.box<Product>('products');
      final categoryProducts = box.values
          .where((p) => p.category.toLowerCase() == categoryName.toLowerCase())
          .toList();
      emit(ProductListLoaded(categoryProducts));
    } catch (e) {
      emit(ProductListError('Failed to load products: ${e.toString()}'));
    }
  }
}