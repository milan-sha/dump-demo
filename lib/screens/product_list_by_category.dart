import 'package:dump/screens/products.dart';
import 'package:flutter/material.dart';

import 'home.dart'; // re-use ProductCard

class ProductListByCategoryPage extends StatelessWidget {
  final String categoryName;

  const ProductListByCategoryPage({
    super.key,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    final List<Product> categoryProducts = allProducts
        .where((p) => p.category == categoryName)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
      ),
      body: categoryProducts.isEmpty
          ? const Center(
        child: Text('No products in this category'),
      )
          : GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.78,
          mainAxisExtent: 300,
        ),
        itemCount: categoryProducts.length,
        itemBuilder: (context, index) {
          final product = categoryProducts[index];
          return ProductCard(
            product: product,
            onAddToCart: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${product.name} added to cart'),
                  backgroundColor: Colors.blue,
                  behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
            onBuyNow: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Buying ${product.name}'),
                  backgroundColor: Colors.orange,
                  behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
