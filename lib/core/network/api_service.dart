import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';
import '../../models/product.dart';
import 'dio_client.dart';
import 'endpoints.dart';

/// Equatable API Response Models
class ProductsResponse  {
  final List<Product> products;
  final int? total;
  final int? skip;
  final int? limit;

  const ProductsResponse({
    required this.products,
    this.total,
    this.skip,
    this.limit,
  });

  factory ProductsResponse.fromJson(Map<String, dynamic> json) {
    return ProductsResponse(
      products: (json['products'] as List<dynamic>?)
          ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
      total: json['total'],
      skip: json['skip'],
      limit: json['limit'],
    );
  }

  @override
  List<Object?> get props => [products, total, skip, limit];
}

class CategoriesResponse extends Equatable {
  final List<String> categories;

  const CategoriesResponse({
    required this.categories,
  });

  factory CategoriesResponse.fromJson(dynamic json) {
    List<String> categories = [];

    if (json is List) {
      categories = List<String>.from(json);
    } else if (json is Map) {
      categories = List<String>.from(json['categories'] ?? json['data'] ?? []);
    }

    return CategoriesResponse(categories: categories);
  }

  @override
  List<Object?> get props => [categories];
}

class ApiService {
  /// Fetch all products from DummyJSON API
  static Future<ProductsResponse> getProducts({
    int limit = 40,
    int skip = 0,
  }) async {
    try {
      final response = await DioClient.get(
        Endpoints.products,
        queryParameters: {'limit': limit, 'skip': skip},
      );
      return ProductsResponse.fromJson(response.data);
    } catch (e) {
      throw ApiException('Error fetching products: $e');
    }
  }

  /// Fetch a single product by ID from DummyJSON API
  static Future<Product> getProductById(int id) async {
    try {
      final response = await DioClient.get('${Endpoints.products}/$id');
      return Product.fromJson(response.data);
    } catch (e) {
      throw ApiException('Error fetching product: $e');
    }
  }

  /// Search products by query
  static Future<ProductsResponse> searchProducts(String query) async {
    try {
      final response = await DioClient.get(
        '${Endpoints.products}/search',
        queryParameters: {'q': query},
      );
      return ProductsResponse.fromJson(response.data);
    } catch (e) {
      throw ApiException('Error searching products: $e');
    }
  }

  /// Get all categories from DummyJSON API
  static Future<List<String>> getCategories() async {
    try {
      final url = Endpoints.categories;
      if (kDebugMode) print('Fetching categories from: $url');

      final response = await DioClient.get(url);

      if (kDebugMode) {
        print('Categories API response status: ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        return CategoriesResponse.fromJson(response.data).categories;
      } else {
        if (kDebugMode) {
          print('Categories API returned status ${response.statusCode}, falling back to products extraction');
        }
        return await _extractCategoriesFromProducts();
      }
    } catch (e) {
      if (kDebugMode) print('Error fetching categories: $e');
      return await _extractCategoriesFromProducts();
    }
  }

  /// Fallback method to extract categories from products
  static Future<List<String>> _extractCategoriesFromProducts() async {
    try {
      final productsResponse = await getProducts(limit: 100);
      return productsResponse.products.map((p) => p.category).toSet().toList();
    } catch (e) {
      throw ApiException('Error fetching categories: $e');
    }
  }

  /// Get products by category name
  static Future<ProductsResponse> getProductsByCategory(
      String categoryName, {
        int limit = 30,
        int skip = 0,
      }) async {
    try {
      final response = await DioClient.get(
        'products/category/$categoryName',
        queryParameters: {'limit': limit, 'skip': skip},
      );
      return ProductsResponse.fromJson(response.data);
    } catch (e) {
      throw ApiException('Error fetching products by category: $e');
    }
  }

  /// Get smartphones category products
  static Future<ProductsResponse> getSmartphones({
    int limit = 30,
    int skip = 0,
  }) async {
    try {
      final response = await DioClient.get(
        Endpoints.smartphones,
        queryParameters: {'limit': limit, 'skip': skip},
      );
      return ProductsResponse.fromJson(response.data);
    } catch (e) {
      throw ApiException('Error fetching smartphones: $e');
    }
  }

  /// Cart operations (keeping as Map for flexibility, but you can create CartResponse too)
  static Future<Map<String, dynamic>> getCarts({
    int limit = 30,
    int skip = 0,
  }) async {
    try {
      final response = await DioClient.get(
        Endpoints.carts,
        queryParameters: {'limit': limit, 'skip': skip},
      );
      return Map<String, dynamic>.from(response.data);
    } catch (e) {
      throw ApiException('Error fetching carts: $e');
    }
  }

  static Future<Map<String, dynamic>> getCartById(int cartId) async {
    try {
      final response = await DioClient.get('${Endpoints.carts}/$cartId');
      return Map<String, dynamic>.from(response.data);
    } catch (e) {
      throw ApiException('Error fetching cart: $e');
    }
  }

  static Future<Map<String, dynamic>> getUserCarts(int userId) async {
    try {
      final response = await DioClient.get('${Endpoints.cartUsers}/$userId');
      return Map<String, dynamic>.from(response.data);
    } catch (e) {
      throw ApiException('Error fetching user carts: $e');
    }
  }

  static Future<Map<String, dynamic>> addCart(Map<String, dynamic> cartData) async {
    try {
      final response = await DioClient.post(
        '${Endpoints.carts}/add',
        data: cartData,
      );
      return Map<String, dynamic>.from(response.data);
    } catch (e) {
      throw ApiException('Error adding cart: $e');
    }
  }

  static Future<Map<String, dynamic>> updateCart(
      int cartId,
      Map<String, dynamic> cartData,
      ) async {
    try {
      final response = await DioClient.put(
        '${Endpoints.carts}/$cartId',
        data: cartData,
      );
      return Map<String, dynamic>.from(response.data);
    } catch (e) {
      throw ApiException('Error updating cart: $e');
    }
  }

  static Future<bool> deleteCart(int cartId) async {
    try {
      final response = await DioClient.delete('${Endpoints.carts}/$cartId');
      return response.statusCode == 200;
    } catch (e) {
      throw ApiException('Error deleting cart: $e');
    }
  }
}

/// Custom Equatable exception for better error handling
class ApiException implements Exception, Equatable {
  final String message;

  const ApiException(this.message);

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'ApiException: $message';

  @override
  // TODO: implement stringify
  bool? get stringify => throw UnimplementedError();
}
