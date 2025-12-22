import 'package:flutter/material.dart';
import 'Universalcheckout.dart';
import 'cart.dart';
import 'products.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  late List<Product> _filteredProducts;

  @override
  void initState() {
    super.initState();
    _filteredProducts = List.from(allProducts);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterProducts(String query) {
    setState(() {
      _filteredProducts = allProducts
          .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dump', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterProducts,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search Products',
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text('${_filteredProducts.length} Products', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ),

          // GRID
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                mainAxisExtent: 310,
              ),
              itemCount: _filteredProducts.length,
              itemBuilder: (context, index) {
                final product = _filteredProducts[index];
                return ProductCard(
                  product: product,
                  onAddToCart: () => _showSnackBar('${product.name} added to cart', Colors.blue),
                  onBuyNow: () {
                    // --- CONNECTED TO UNIVERSAL CHECKOUT ---
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// --- PRODUCT CARD COMPONENT ---
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onAddToCart;
  final VoidCallback onBuyNow;

  const ProductCard({super.key, required this.product, required this.onAddToCart, required this.onBuyNow});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailScreen(product: product)));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Hero(
                tag: product.name,
                child: Image.asset(product.assetPath, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.image)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, maxLines: 1, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  Text('₹${product.price.toStringAsFixed(0)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                          onPressed: onAddToCart,
                          child: const Text('Cart', style: TextStyle(color: Colors.white, fontSize: 12)),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                          onPressed: onBuyNow,
                          child: const Text('Buy', style: TextStyle(color: Colors.white, fontSize: 12)),
                        ),
                      ),
                    ],
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

// --- PRODUCT DETAIL SCREEN ---
class ProductDetailScreen extends StatelessWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Hero(tag: product.name, child: Image.asset(product.assetPath, width: double.infinity, height: 350, fit: BoxFit.cover)),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  Text('₹${product.price.toStringAsFixed(0)}', style: const TextStyle(fontSize: 24, color: Colors.green, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 20),
                  const Text("About this product", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const Text("Premium quality product. Durable and modern design.", style: TextStyle(fontSize: 16, color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, padding: const EdgeInsets.symmetric(vertical: 16)),
          onPressed: () {
            // --- CONNECTED TO UNIVERSAL CHECKOUT ---
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
          child: const Text("Buy Now", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}