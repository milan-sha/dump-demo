import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/hive_products.dart';

class ProductListByCategoryPage extends StatelessWidget {
  final String categoryName;
  const ProductListByCategoryPage({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    // This is a placeholder for your logic to filter products by category from Hive
    final List<Product> products = [];

    return Scaffold(
      appBar: AppBar(title: Text(categoryName)),
      body: products.isEmpty
          ? const Center(child: Text("No products in this category"))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return _ProductItemCard(product: product);
        },
      ),
    );
  }
}

// --- FIXED: Added missing _ProductItemCard definition ---
class _ProductItemCard extends StatelessWidget {
  final Product product;
  const _ProductItemCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(8),
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Image.asset(product.assetPath, fit: BoxFit.contain),
        ),
        title: Text(product.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('₹${product.price}', style: const TextStyle(color: Colors.green)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => context.push('/product-detail', extra: product),
      ),
    );
  }
}