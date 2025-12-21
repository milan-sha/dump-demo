// lib/products.dart - SIMPLIFIED (No discount/reviews)
class Product {
  final String id;
  final String name;
  final double price;
  final String assetPath;
  final String category;
  final String description;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.assetPath,
    required this.category,
    this.description = '',
  });

  String get formattedPrice => '₹${price.toStringAsFixed(0)}';
}

const List<Product> allProducts = [
  const Product(
    id: '1',
    name: 'Nike Air Max 90 Black',
    price: 4999,
    assetPath: 'assets/Nike black.jpg',
    category: 'Shoes',
    description: 'Premium running shoes with maximum cushioning and breathable mesh upper.',
  ),
  const Product(
    id: '2',
    name: 'Nike Air Force 1 Red',
    price: 5999,
    assetPath: 'assets/red shoe.jpg',
    category: 'Shoes',
    description: 'Classic lifestyle sneakers in vibrant red colorway.',
  ),
  const Product(
    id: '3',
    name: 'Organic Face Cream',
    price: 899,
    assetPath: 'assets/face cream.jpg',
    category: 'Cosmetics',
    description: 'Natural moisturizer with vitamin C & hyaluronic acid for glowing skin.',
  ),
  const Product(
    id: '4',
    name: 'Nordic Wooden Chair',
    price: 2999,
    assetPath: 'assets/chair.jpg',
    category: 'Furniture',
    description: 'Minimalist oak wood dining chair with modern design.',
  ),
  const Product(
    id: '5',
    name: 'Eco Leather Green Bag',
    price: 1299,
    assetPath: 'assets/greenbag.jpg',
    category: 'Fashion',
    description: 'Sustainable vegan leather crossbody bag with premium finish.',
  ),
  const Product(
    id: '6',
    name: 'Glass Water Bottle',
    price: 399,
    assetPath: 'assets/bottle.jpg',
    category: 'Fashion',
    description: 'BPA-free reusable glass bottle with protective silicone sleeve.',
  ),
];

List<Product> getProductsByCategory(String category) {
  return allProducts.where((p) => p.category == category).toList();
}

List<String> getCategories() {
  return allProducts.map((p) => p.category).toSet().toList();
}
