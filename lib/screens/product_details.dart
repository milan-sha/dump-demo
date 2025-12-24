import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'cart.dart';
import 'products.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  // Add to cart function
  void _addToCart(BuildContext context) {
    final existingIndex =
    cartItems.indexWhere((item) => item.name == product.name);

    if (existingIndex >= 0) {
      cartItems[existingIndex].quantity++;
    } else {
      cartItems.add(
        CartItem(
          name: product.name,
          image: product.assetPath,
          price: product.price,
          quantity: 1,
        ),
      );
    }

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to cart!'),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Hero(
              tag: product.name,
              child: Image.asset(
                product.assetPath,
                width: double.infinity,
                height: 350,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name,
                      style: const TextStyle(
                          fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('₹${product.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                          fontSize: 24,
                          color: Colors.green,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 20),
                  const Text("About this product",
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(product.description.isNotEmpty
                      ? product.description
                      : "Premium quality product from Dump. Durable and modern design. Perfect for your daily needs with high-performance materials.",
                      style: const TextStyle(
                          fontSize: 16, color: Colors.grey, height: 1.5)),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _addToCart(context),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.blue, width: 2),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("ADD TO CART",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Go to checkout page with only this product
                    context.push('/checkout', extra: [
                      CartItem(
                        name: product.name,
                        image: product.assetPath,
                        price: product.price,
                        quantity: 1,
                      )
                    ]);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                  child: const Text(
                    "BUY NOW",
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}