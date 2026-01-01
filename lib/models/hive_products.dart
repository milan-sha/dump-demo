import 'package:hive_ce/hive_ce.dart';

part 'hive_products.g.dart';

@HiveType(typeId: 1)
class Product extends HiveObject {
  @HiveField(0)
  final String category;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final double price;
  @HiveField(4)
  final String brand;


  Product({
    required this.category,
    required this.title,
    required this.description,
    required this.price,
    required this.brand,
  });
  String get name => title;
  String get assetPath => 'assets/default_product.jpg';

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      category: json['category'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num).toDouble(),
      brand: json['brand'] ?? '',
    );
  }
}