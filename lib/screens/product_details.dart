// --- PRODUCT DETAIL SCREEN ---
import 'package:dump/screens/products.dart';
import 'package:flutter/material.dart';
import 'Universalcheckout.dart';
import 'cart.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  void _showAddedSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to cart!'),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'VIEW CART',
          textColor: Colors.white,
          onPressed: () {
          },
        ),
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
                errorBuilder: (c, e, s) => Container(
                  height: 350,
                  color: Colors.grey[200],
                  child: const Icon(Icons.image_not_supported, size: 50),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('₹${product.price.toStringAsFixed(0)}',
                      style: const TextStyle(fontSize: 24, color: Colors.green, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 20),
                  const Text("About this product", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text(
                      "Premium quality product from Dump. Durable and modern design. Perfect for your daily needs with high-performance materials.",
                      style: TextStyle(fontSize: 16, color: Colors.grey, height: 1.5)
                  ),
                  const SizedBox(height: 100), // Extra space so buttons don't cover text
                ],
              ),
            ),
          ],
        ),
      ),
      // TWO BUTTONS AT THE BOTTOM
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, -2))],
        ),
        child: SafeArea(
          child: Row(
            children: [
              // ADD TO CART BUTTON
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.blue, width: 2),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => _showAddedSnackBar(context),
                  child: const Text("ADD TO CART",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue)),
                ),
              ),
              const SizedBox(width: 12),
              // BUY NOW BUTTON
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UniversalCheckout(
                          checkoutItems: [
                            CartItem(
                              name: product.name,
                              image: product.assetPath,
                              price: product.price,
                              quantity: 1,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: const Text("BUY NOW",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}