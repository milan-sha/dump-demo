import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/product.dart';
import 'endpoints.dart';

class ApiService {
  /// Fetch all products from DummyJSON API
  static Future<List<Product>> getProducts({
    int limit = 30,
    int skip = 0,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('${Endpoints.baseUrl}${Endpoints.products}?limit=$limit&skip=$skip'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> productsJson = data['products'] ?? [];
        return productsJson.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  /// Fetch a single product by ID from DummyJSON API
  static Future<Product> getProductById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('${Endpoints.baseUrl}${Endpoints.products}/$id'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Product.fromJson(data);
      } else {
        throw Exception('Failed to load product: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching product: $e');
    }
  }

  /// Search products by query
  static Future<List<Product>> searchProducts(String query) async {
    try {
      final response = await http.get(
        Uri.parse('${Endpoints.baseUrl}${Endpoints.products}/search?q=$query'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> productsJson = data['products'] ?? [];
        return productsJson.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching products: $e');
    }
  }
}
