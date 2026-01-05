part of 'product_category_by___cubit.dart';

class ProductListState extends Equatable {
  final ProductListStatus productListStatus;
  final List<Product> products;
  final String? errorMessage;

  const ProductListState({
    this.productListStatus = ProductListStatus.initial,
    this.products = const [],
    this.errorMessage,
  });

  ProductListState copyWith({
    ProductListStatus? productListStatus,
    List<Product>? products,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return ProductListState(
      productListStatus: productListStatus ?? this.productListStatus,
      products: products ?? this.products,
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [productListStatus, products, errorMessage];
}

enum ProductListStatus { initial, loading, loaded, error }