import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce/hive_ce.dart';
import '../../../models/hive_products.dart';
import '../product_category.dart';
import 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(CategoryInitial()) {
    loadCategories();
  }

  Future<void> loadCategories() async {
    emit(CategoryLoading());

    try {
      var box = Hive.box<Product>('products');
      List<Product> allProducts = box.values.toList();
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
        emit(CategoryLoaded(categories));
      }
    } catch (e) {
      emit(CategoryError('Failed to sync categories: $e'));
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