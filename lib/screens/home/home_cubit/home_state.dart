part of 'home_cubit.dart';

class HomeState extends Equatable {
  final HomeStatus homeStatus;
  final List<Product> allProducts;
  final List<Product> filteredProducts;
  final String? errorMessage;

  const HomeState({
    this.homeStatus = HomeStatus.initial,
    this.allProducts = const [],
    this.filteredProducts = const [],
    this.errorMessage,
  });

  HomeState copyWith({
    HomeStatus? homeStatus,
    List<Product>? allProducts,
    List<Product>? filteredProducts,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return HomeState(
      homeStatus: homeStatus ?? this.homeStatus,
      allProducts: allProducts ?? this.allProducts,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [homeStatus, allProducts, filteredProducts, errorMessage];
}

enum HomeStatus { initial, loading, loaded, error }