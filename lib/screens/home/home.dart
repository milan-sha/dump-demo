import 'package:dump/screens/cart/cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../models/hive_products.dart';

// Import the Cart Cubit and State
import '../cart/cart_cubit/cart_cubit.dart';
import 'home_cubit/home_cubit.dart';
import 'home_cubit/home_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Note: Usually BlocProvider is placed higher up (like in main.dart)
    // but if you want it specifically here, this works.
    return BlocProvider(
      create: (context) => HomeCubit()..loadProducts(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('DUMP',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Builder(
                builder: (context) => TextField(
                  onChanged: (query) => context.read<HomeCubit>().filterProducts(query),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'Search sneakers...',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  if (state is HomeLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is HomeLoaded) {
                    final products = state.filteredProducts;

                    if (products.isEmpty) {
                      return const Center(child: Text("No products found."));
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        mainAxisExtent: 280,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) => ProductCard(product: products[index]),
                    );
                  }
                  return const Center(child: Text("Something went wrong."));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  // FIXED: Logic moved to use CartCubit
  void _handleAddToCart(BuildContext context) {
    // Instead of manually editing a list, tell the Cubit to handle it
    context.read<CartCubit>().addToCart(product as CartItem);

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.title} added to cart!'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/product-detail', extra: product),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    child: Image.asset(
                      product.assetPath,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  ),
                  // ADD TO CART BUTTON
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => _handleAddToCart(context),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.blueAccent,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.add_shopping_cart,
                            color: Colors.white, size: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '₹${product.price.toStringAsFixed(0)}',
                    style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}