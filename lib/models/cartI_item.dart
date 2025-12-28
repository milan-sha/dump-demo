import 'package:hive_ce_flutter/adapters.dart';

@HiveType(typeId: 0)
class CartItem {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String image;

  @HiveField(2)
  final double price;

  @HiveField(3)
  int quantity;

  CartItem({
    required this.name,
    required this.image,
    required this.price,
    this.quantity = 1,
  });
}
