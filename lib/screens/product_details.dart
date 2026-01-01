import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../models/hive_products.dart';
import 'cart/cart.dart';
import 'cart/cart_cubit/cart_cubit.dart'; // Access global cartItems

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. STYLIZED HERO BANNER (No image dependency)
            Hero(
              tag: product.title,
              child: Container(
                width: double.infinity,
                height: 350,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.blue.shade300, Colors.blue.shade700],
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: const Icon(Icons.shopping_bag_outlined, size: 120, color: Colors.white),
              ),
            ),

            // 2. PRODUCT INFO
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.category.toUpperCase(),
                        style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                      ),
                      Text(
                        "₹${product.price.toStringAsFixed(0)}",
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(product.title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  const Text("Description", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    "High-quality ${product.title} in the ${product.category} category. Designed for comfort and durability.",
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade700, height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // 3. STRUCTURED ACTION BUTTONS
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: Row(
          children: [
            // BUTTON 1: ADD TO CART
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.blue.shade700, width: 2),
                  minimumSize: const Size(0, 55),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: () {
                  _addToCart(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("${product.title} added to cart!")),
                  );
                },
                child: Text("ADD TO CART", style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(width: 15),
            // BUTTON 2: BUY NOW (Direct to Checkout)
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  minimumSize: const Size(0, 55),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: () {
                  // Create a temporary list for immediate checkout
                  final directItem = CartItem(
                    name: product.title,
                    price: product.price,
                    quantity: 1,
                  );
                  context.push('/checkout', extra: [directItem]);
                },
                child: const Text("BUY NOW", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Logic helper to keep build method clean
// Inside ProductDetailScreen _addToCart method
  void _addToCart(BuildContext context) {
    final cartItem = CartItem(
      name: product.title,
      price: product.price,
      quantity: 1,
    );

    context.read<CartCubit>().addToCart(cartItem);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Added to Cart!")),
    );
  }
}