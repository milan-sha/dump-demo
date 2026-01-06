import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../models/product.dart';
import 'cart/cart.dart';
import 'cart/cart_cubit/cart_cubit.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. PRODUCT IMAGE HERO
            Hero(
              tag: product.title,
              child: Container(
                width: double.infinity,
                height: 300,
                color: Colors.grey[50],
                // UPDATED: Now uses Network Image from API
                child: Image.network(
                  product.thumbnail,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, size: 100, color: Colors.grey),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 2. CATEGORY & BRAND
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.category.toUpperCase(),
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Text(
                        product.brand,
                        style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // 3. TITLE & PRICE
                  Text(
                    product.title,
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 4. DESCRIPTION
                  const Text(
                    "Description",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    style: TextStyle(color: Colors.grey[600], height: 1.5, fontSize: 15),
                  ),
                  const SizedBox(height: 100), // Space for bottom buttons
                ],
              ),
            ),
          ],
        ),
      ),

      // 5. BOTTOM ACTION BAR
      bottomSheet: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5))
          ],
        ),
        child: Row(
          children: [
            // ADD TO CART
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 55),
                  side: BorderSide(color: Colors.blue.shade700),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: () => _addToCart(context),
                child: Text("ADD TO CART",
                    style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(width: 15),
            // BUY NOW
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  minimumSize: const Size(0, 55),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: () {
                  final directItem = CartItem(
                    productId: product.id,
                    name: product.title,
                    price: product.price,
                    quantity: 1,
                  );
                  context.push('/checkout', extra: [directItem]);
                },
                child: const Text("BUY NOW",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addToCart(BuildContext context) {
    final cartItem = CartItem(
      productId: product.id,
      name: product.title,
      price: product.price,
      quantity: 1,
    );

    context.read<CartCubit>().addToCart(cartItem);

  }
}