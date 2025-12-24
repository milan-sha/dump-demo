import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'products.dart';

class ProductListByCategoryPage extends StatelessWidget {
  final String categoryName;
  const ProductListByCategoryPage({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    final categoryProducts = allProducts.where((p) => p.category == categoryName).toList();

    return Scaffold(
      appBar: AppBar(title: Text(categoryName)),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: categoryProducts.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: 0.78,
        ),
        itemBuilder: (context, index) {
          final product = categoryProducts[index];
          return GestureDetector(
            onTap: () => context.push('/product-detail', extra: product),
            child: Card(
              child: Column(
                children: [
                  Image.asset(product.assetPath, height: 120, fit: BoxFit.cover),
                  Text(product.name),
                  Text("₹${product.price.toStringAsFixed(0)}"),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}