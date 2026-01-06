import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/product.dart';
import '../../../core/network/api_service.dart';
import '../product_categoryz_by_list/product_category.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(const CategoryState());

  /// Loads categories from DummyJSON API
  Future<void> loadCategories() async {
    emit(state.copyWith(categoryStatus: CategoryStatus.loading, clearErrorMessage: true));

    try {
      // 1. Get categories from API
      List<String> categoryNames = await ApiService.getCategories();

      if (categoryNames.isEmpty) {
        emit(state.copyWith(
          categoryStatus: CategoryStatus.error,
          errorMessage: 'No categories found.',
        ));
        return;
      }

      // 2. Get products to get thumbnail images for each category
      List<Product> sampleProducts = [];
      try {
        final productsResponse = await ApiService.getProducts(limit: 100);
        sampleProducts = productsResponse.products;
      } catch (e) {
        // If we can't get products, we'll use a placeholder
        if (kDebugMode) {
          print('Warning: Could not fetch products for category thumbnails: $e');
        }
      }

      // 3. Map category names to ProductCategory objects with dynamic styling
      final List<ProductCategory> categories = [];

      // Fetch one product per category in parallel for better performance
      final List<Future<Product?>> productFutures = categoryNames.map((name) async {
        // First try to find in sample products
        try {
          return sampleProducts.firstWhere(
                (p) => p.category.toLowerCase() == name.toLowerCase(),
          );
        } catch (e) {
          // If not found, fetch from category API
          try {
            final categoryResponse = await ApiService.getProductsByCategory(name, limit: 1);
            return categoryResponse.products.isNotEmpty ? categoryResponse.products.first : null;
          } catch (e) {
            if (kDebugMode) print('Failed to fetch products for category $name: $e');
            return null;
          }
        }
      }).toList();

      final categoryProducts = await Future.wait(productFutures);

      for (int i = 0; i < categoryNames.length; i++) {
        final name = categoryNames[i];
        final categoryProduct = categoryProducts[i];

        categories.add(ProductCategory(
          name: name,
          image: categoryProduct?.thumbnail ?? 'https://via.placeholder.com/150',
          color: _getCategoryColor(name),
          icon: _getCategoryIcon(name),
        ));
      }

      emit(state.copyWith(
        categoryStatus: CategoryStatus.loaded,
        categories: categories,
      ));

    } on ApiException catch (e) {
      if (kDebugMode) {
        print('API Error loading categories: ${e.message}');
      }
      emit(state.copyWith(
        categoryStatus: CategoryStatus.error,
        errorMessage: e.message,
      ));
    } catch (e) {
      if (kDebugMode) {
        print('Unexpected error loading categories: $e');
      }
      emit(state.copyWith(
        categoryStatus: CategoryStatus.error,
        errorMessage: 'Failed to load categories: ${e.toString()}',
      ));
    }
  }

  // UPDATED: Added cases for DummyJSON specific categories
  Color _getCategoryColor(String name) {
    switch (name.toLowerCase()) {
      case 'smartphones':
      case 'smartphone':
        return Colors.blue;
      case 'laptops':
      case 'laptop':
        return Colors.deepPurple;
      case 'fragrances':
        return Colors.pink;
      case 'skincare':
        return Colors.green;
      case 'groceries':
        return Colors.orange;
      case 'home decoration':
      case 'home-decoration':
        return Colors.brown;
      case 'furniture':
        return Colors.amber;
      default:
        return Colors.blueGrey;
    }
  }

  // UPDATED: Added icons for DummyJSON specific categories
  IconData _getCategoryIcon(String name) {
    switch (name.toLowerCase()) {
      case 'smartphones':
      case 'smartphone':
        return Icons.phone_android;
      case 'laptops':
      case 'laptop':
        return Icons.laptop;
      case 'fragrances':
        return Icons.local_florist;
      case 'skincare':
        return Icons.face;
      case 'groceries':
        return Icons.shopping_basket;
      case 'home decoration':
      case 'home-decoration':
        return Icons.home;
      case 'furniture':
        return Icons.chair;
      default:
        return Icons.category;
    }
  }
}
