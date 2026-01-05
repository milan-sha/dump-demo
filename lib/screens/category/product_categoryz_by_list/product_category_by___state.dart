import '../../../models/hive_products.dart';

abstract class ProductListState {}

class ProductListInitial extends ProductListState {}

class ProductListLoading extends ProductListState {}

class ProductListLoaded extends ProductListState {
  final List<Product> products;
  ProductListLoaded(this.products);
}

class ProductListError extends ProductListState {
  final String message;
  ProductListError(this.message);
}