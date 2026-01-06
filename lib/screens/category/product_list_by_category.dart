import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../models/product.dart';
import 'product_categoryz_by_list/product_category_by___cubit.dart';

class ProductListByCategoryPage extends StatelessWidget {
  final String categoryName;

  const ProductListByCategoryPage({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Initialize the Cubit and immediately trigger the category filter
      create: (context) => ProductListCubit()..loadProductsByCategory(categoryName),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            categoryName.toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: BlocBuilder<ProductListCubit, ProductListState>(
          builder: (context, state) {
            // 1. Loading State
            if (state.productListStatus == ProductListStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            // 2. Error State
            if (state.productListStatus == ProductListStatus.error) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(state.errorMessage ?? "Failed to load products"),
                  ],
                ),
              );
            }

            // 3. Empty State
            if (state.products.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey[300]),
                    const SizedBox(height: 16),
                    const Text("No products found in this category",
                        style: TextStyle(color: Colors.grey, fontSize: 16)),
                  ],
                ),
              );
            }

            // 4. Loaded State
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                final product = state.products[index];
                return _ProductItemCard(product: product);
              },
            );
          },
        ),
      ),
    );
  }
}

class _ProductItemCard extends StatelessWidget {
  final Product product;
  const _ProductItemCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
          ),
          // UPDATED: Loading images from API URL
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              product.thumbnail,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.broken_image, color: Colors.grey),
            ),
          ),
        ),
        title: Text(
          product.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(product.brand, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
            const SizedBox(height: 4),
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                  color: Colors.green, fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.blue),
        onTap: () => context.push('/product-detail', extra: product),
      ),
    );
  }
}