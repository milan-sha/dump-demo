part of 'home_cubit.dart';

enum HomeStatus { initial, loading, loadingMore, loaded, error }

class HomeState extends Equatable {
  final HomeStatus homeStatus;
  final List<Product> allProducts;
  final List<Product> filteredProducts;
  final String? errorMessage;
  final int totalProducts;
  final int currentPage;
  final int totalPages;

  const HomeState({
    this.homeStatus = HomeStatus.initial,
    this.allProducts = const [],
    this.filteredProducts = const [],
    this.errorMessage,
    this.totalProducts = 0,
    this.currentPage = 1,
    this.totalPages = 1,
  });

  HomeState copyWith({
    HomeStatus? homeStatus,
    List<Product>? allProducts,
    List<Product>? filteredProducts,
    String? errorMessage,
    int? totalProducts,
    int? currentPage,
    int? totalPages,
    bool clearErrorMessage = false,
  }) {
    return HomeState(
      homeStatus: homeStatus ?? this.homeStatus,
      allProducts: allProducts ?? this.allProducts,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
      totalProducts: totalProducts ?? this.totalProducts,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
    );
  }

  @override
  List<Object?> get props => [
    homeStatus,
    allProducts,
    filteredProducts,
    errorMessage,
    totalProducts,
    currentPage,
    totalPages,
  ];
}
