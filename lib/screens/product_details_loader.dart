import 'package:flutter/material.dart';
import '../core/network/api_service.dart';
import '../models/product.dart';
import 'product_details.dart';

class ProductDetailLoader extends StatelessWidget {
  final int productId;

  const ProductDetailLoader({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Product>(
      future: ApiService.getProductById(productId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error loading product: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            ),
          );
        }

        if (snapshot.hasData) {
          return ProductDetailScreen(product: snapshot.data!);
        }

        return Scaffold(
          appBar: AppBar(),
          body: const Center(child: Text('Product not found')),
        );
      },
    );
  }
}
