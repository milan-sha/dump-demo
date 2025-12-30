import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../cart.dart'; // Ensure this points to your global cartItems list
import '../products.dart';
import 'home_cubit/home_cubit.dart';
import 'home_cubit/home_state.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Provide the Cubit and pass the initial products list
    return BlocProvider(
      create: (context) => HomeCubit(allProducts),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dump', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
        ),
        body: Column(
          children: [
            // SEARCH BAR
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Builder(
                builder: (context) => TextField(
                  onChanged: (query) => context.read<HomeCubit>().filterProducts(query),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'Search Products',
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

            // PRODUCT GRID
            Expanded(
              child: BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  if (state is HomeLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is HomeLoaded) {
                    return GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        mainAxisExtent: 310,
                      ),
                      itemCount: state.filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = state.filteredProducts[index];
                        // Using the ProductCard defined below
                        return ProductCard(product: product);
                      },
                    );
                  }
                  return const Center(child: Text("No products found"));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// THE MISSING WIDGET (ProductCard)
class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  void _handleAddToCart(BuildContext context) {
    // 1. Logic to update the global cart list immediately
    final existingIndex = cartItems.indexWhere((item) => item.name == product.name);

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

    // 2. Feedback to user (Stay on same page)
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to cart!'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.blue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/product-detail', extra: product),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Image.asset(product.assetPath, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, maxLines: 1, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text('₹${product.price.toStringAsFixed(0)}', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () => _handleAddToCart(context),
                      child: const Text('Add to Cart', style: TextStyle(color: Colors.white, fontSize: 10)),
                    ),
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