import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/hive_products.dart';
import '../../../service/storage _service.dart';
import '../product_categoryz_by_list/product_category.dart';
import 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> with StorageServiceMixin, StoragesServiceMixin {
  CategoryCubit() : super(CategoryInitial()) {
    loadCategories();
  }

  Future<void> loadCategories() async {
    emit(CategoryLoading());

    try {
      List<Product> allProducts = getHiveProducts();
      final uniqueCategoryNames = allProducts.map((p) => p.category).toSet().toList();
      final categories = uniqueCategoryNames.map((name) {
        return ProductCategory(
          name: name,
          image: 'assets/${name.toLowerCase()}.jpg',
          color: _getCategoryColor(name),
          icon: _getCategoryIcon(name),
        );
      }).toList();
      if (categories.isEmpty) {
        emit(CategoryError('No categories found in the database.'));
      } else {
        // Save categories using addData
        await saveCategories(categories);
        emit(CategoryLoaded(categories));
      }
    } catch (e) {
      emit(CategoryError('Failed to sync categories: $e'));
    }
  }

  Future<void> saveCategories(List<ProductCategory> categories) async {
    try {
      // Save the list of category names using addData
      final categoryNames = categories.map((c) => c.name).toList();
      await addData(MainBoxKeys.category, categoryNames);
    } catch (e) {
      // Handle error silently or log it
    }
  }

  Future<void> saveSelectedCategory(String categoryName) async {
    try {
      // Save the selected category using addData
      await addData(MainBoxKeys.category, categoryName);
    } catch (e) {
      // Handle error silently or log it
    }
  }
  Color _getCategoryColor(String name) {
    switch (name.toLowerCase()) {
      case 'shoes': return Colors.blue;
      case 'fashion': return Colors.pink;
      case 'electronics': return Colors.orange;
      default: return Colors.grey;
    }
  }
  IconData _getCategoryIcon(String name) {
    switch (name.toLowerCase()) {
      case 'shoes': return Icons.directions_run;
      case 'fashion': return Icons.checkroom;
      default: return Icons.category;
    }
  }
}