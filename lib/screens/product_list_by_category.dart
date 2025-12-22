import 'package:flutter/material.dart';
import 'home.dart';
import 'products.dart';
import 'cart_screen.dart' ;
import 'cart.dart';
import 'Universalcheckout.dart';

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
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
              // Add to global cart
              final existingIndex = cartItems.indexWhere(
                      (item) => item.name == product.name);
              if (existingIndex >= 0) {
                cartItems[existingIndex].quantity++;
              } else {
                cartItems.add(CartItem(
                  name: product.name,
                  image: product.assetPath,
                  price: product.price,
                ));
              }

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CartScreen(),
                ),
              );
            },
            onBuyNow: () {
              // Directly go to checkout
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => UniversalCheckout(
                    checkoutItems: [
                      CartItem(
                        name: product.name,
                        image: product.assetPath,
                        price: product.price,
                      )
                    ],
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
