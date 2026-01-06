class Product {
  final int id;
  final String category;
  final String title;
  final String description;
  final double price;
  final String brand;
  final String thumbnail;
  final List<String>? images;

  Product({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    required this.price,
    required this.brand,
    required this.thumbnail,
    this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      category: json['category'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      brand: json['brand'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      images: json['images'] != null 
          ? List<String>.from(json['images'] as List)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'title': title,
      'description': description,
      'price': price,
      'brand': brand,
      'thumbnail': thumbnail,
      'images': images,
    };
  }
}
