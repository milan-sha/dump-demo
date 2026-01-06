part of 'product_list_cubit.dart';





enum ProductListStatus { initial, loading, loaded, error }

class ProductListState extends Equatable {
  final ProductListStatus productListStatus;
  final List<Product> products;
  final String? errorMessage;
  final String? currentCategory;
  final int totalProducts;
  final int currentPage;
  final int totalPages;

  const ProductListState({
    this.productListStatus = ProductListStatus.initial,
    this.products = const [],
    this.errorMessage,
    this.currentCategory,
    this.totalProducts = 0,
    this.currentPage = 1,
    this.totalPages = 1,
  });

  ProductListState copyWith({
    ProductListStatus? productListStatus,
    List<Product>? products,
    String? errorMessage,
    String? currentCategory,
    int? totalProducts,
    int? currentPage,
    int? totalPages,
    bool clearErrorMessage = false,
  }) {
    return ProductListState(
      productListStatus: productListStatus ?? this.productListStatus,
      products: products ?? this.products,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
      currentCategory: currentCategory ?? this.currentCategory,
      totalProducts: totalProducts ?? this.totalProducts,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
    );
  }

  @override
  List<Object?> get props => [
    productListStatus,
    products,
    errorMessage,
    currentCategory,
    totalProducts,
    currentPage,
    totalPages,
  ];
}
