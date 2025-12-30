import '../../products.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Product> allProducts;
  final List<Product> filteredProducts;

  HomeLoaded({required this.allProducts, required this.filteredProducts});
}