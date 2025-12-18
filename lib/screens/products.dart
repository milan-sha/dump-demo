class Product {
  final String name;
  final double price;
  final String assetPath;
  final String category;

  const Product({
    required this.name,
    required this.price,
    required this.assetPath,
    required this.category,
  });
}

const List<Product> allProducts = [
  Product(
    name: 'Nike black Shoe',
    price: 4999,
    assetPath: 'assets/Nike black.jpg',
    category: 'Shoes',
  ),
  Product(
    name: 'Nike red Shoe',
    price: 5999,
    assetPath: 'assets/red shoe.jpg',
    category: 'Shoes',
  ),
  Product(
    name: 'Face cream',
    price: 899,
    assetPath: 'assets/face cream.jpg',
    category: 'Cosmetics',
  ),

  Product(
    name: 'Wooden chair',
    price: 2999,
    assetPath: 'assets/chair.jpg',
    category: 'Furniture',
  ),

  Product(
    name: ' Green bag',
    price: 1299,
    assetPath: 'assets/greenbag.jpg',
    category: 'Fashion',
  ),
  Product(
    name: 'Green bottle',
    price: 399,
    assetPath: 'assets/bottle.jpg',
    category: 'Fashion',
  ),
];
