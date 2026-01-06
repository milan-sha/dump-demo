part of 'category_cubit.dart';

enum CategoryStatus { initial, loading, loaded, error }

class CategoryState extends Equatable {
  final CategoryStatus categoryStatus;
  final List<ProductCategory> categories;
  final String? errorMessage;

  const CategoryState({
    this.categoryStatus = CategoryStatus.initial,
    this.categories = const [],
    this.errorMessage,
  });

  CategoryState copyWith({
    CategoryStatus? categoryStatus,
    List<ProductCategory>? categories,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return CategoryState(
      categoryStatus: categoryStatus ?? this.categoryStatus,
      categories: categories ?? this.categories,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [categoryStatus, categories, errorMessage];
}
