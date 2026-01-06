import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/product.dart';
import '../../../core/network/api_service.dart';
import '../product_categoryz_by_list/product_category.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(const CategoryState());

  /// Dynamically generates categories based on products from API
  Future<void> loadCategories() async {
    emit(state.copyWith(categoryStatus: CategoryStatus.loading, clearErrorMessage: true));

    try {
      // 1. Get products from API
      List<Product> allProducts = await ApiService.getProducts();

      if (allProducts.isEmpty) {
        emit(state.copyWith(
          categoryStatus: CategoryStatus.error,
          errorMessage: 'No products found.',
        ));
        return;
      }

      // 2. Extract unique category names
      final uniqueCategoryNames = allProducts.map((p) => p.category).toSet().toList();

      // 3. Map names to ProductCategory objects with dynamic styling
      final categories = uniqueCategoryNames.map((name) {
        return ProductCategory(
          name: name,
          // Using a placeholder or the first product's thumbnail as the category image
          image: allProducts.firstWhere((p) => p.category == name).thumbnail,
          color: _getCategoryColor(name),
          icon: _getCategoryIcon(name),
        );
      }).toList();

      emit(state.copyWith(
        categoryStatus: CategoryStatus.loaded,
        categories: categories,
      ));

    } catch (e) {
      emit(state.copyWith(
        categoryStatus: CategoryStatus.error,
        errorMessage: 'Failed to load categories: $e',
      ));
    }
  }

  // UPDATED: Added cases for DummyJSON specific categories
  Color _getCategoryColor(String name) {
    switch (name.toLowerCase()) {
      case 'smartphones': return Colors.blue;
      case 'laptops': return Colors.deepPurple;
      case 'fragrances': return Colors.pink;
      case 'skincare': return Colors.green;
      case 'groceries': return Colors.orange;
      case 'home-decoration': return Colors.brown;
      default: return Colors.blueGrey;
    }
  }

  // UPDATED: Added icons for DummyJSON specific categories
  IconData _getCategoryIcon(String name) {
    switch (name.toLowerCase()) {
      case 'smartphones': return Icons.phone_android;
      case 'laptops': return Icons.laptop;
      case 'fragrances': return Icons.h_mobiledata_sharp;
      case 'skincare': return Icons.face;
      case 'groceries': return Icons.shopping_basket;
      case 'home-decoration': return Icons.deck;
      default: return Icons.category;
    }
  }
}