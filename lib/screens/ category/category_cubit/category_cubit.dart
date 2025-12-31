import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../product_category.dart';
import 'category_state.dart';


class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(CategoryInitial()) {
    loadCategories();
  }

  Future<void> loadCategories() async {
    emit(CategoryLoading());

    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final categories = [
        ProductCategory(
          name: 'Shoes',
          image: 'assets/grpshoes.jpg',
          color: Colors.blue,
          icon: Icons.directions_run,
        ),
        ProductCategory(
          name: 'Fashion',
          image: 'assets/greenbag.jpg',
          color: Colors.pink,
          icon: Icons.checkroom,
        ),
        ProductCategory(
          name: 'Cosmetics',
          image: 'assets/cosmetics.jpg',
          color: Colors.green,
          icon: Icons.brush,
        ),
        ProductCategory(
          name: 'Furniture',
          image: 'assets/grpfurn.jpg',
          color: Colors.orange,
          icon: Icons.chair_alt,
        ),
      ];
      emit(CategoryLoaded(categories));
    } catch (e) {
      emit(CategoryError('Failed to load categories: $e'));
    }
  }
}
