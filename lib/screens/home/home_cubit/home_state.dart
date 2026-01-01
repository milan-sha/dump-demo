import '../../../models/hive_products.dart';

abstract class HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Product> allProducts;
  final List<Product> filteredProducts;

  HomeLoaded({required this.allProducts, required this.filteredProducts});
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}