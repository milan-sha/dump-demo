import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'category_cubit/category_cubit.dart';
import 'product_categoryz_by_list/product_category.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Ensure the cubit loads categories as soon as the screen is built
      create: (context) => CategoryCubit()..loadCategories(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'Categories',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: BlocBuilder<CategoryCubit, CategoryState>(
          builder: (context, state) {
            // 1. Loading State
            if (state.categoryStatus == CategoryStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            // 2. Error State
            if (state.categoryStatus == CategoryStatus.error) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.category_outlined, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(state.errorMessage ?? "Failed to load categories"),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<CategoryCubit>().loadCategories(),
                      child: const Text("Retry"),
                    )
                  ],
                ),
              );
            }

            // 3. Success State
            return RefreshIndicator(
              onRefresh: () => context.read<CategoryCubit>().loadCategories(),
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85, // Adjusted to fit image + text better
                ),
                itemCount: state.categories.length,
                itemBuilder: (context, index) {
                  final category = state.categories[index];
                  return _CategoryCard(
                    category: category,
                    onTap: () {
                      // Navigates to the product list page for this specific category
                      context.push('/category-products', extra: category.name);
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final ProductCategory category;
  final VoidCallback onTap;

  const _CategoryCard({required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Column(
          children: [
            // Category Image (Fetched from the first product thumbnail in that category)
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: category.color.withValues(alpha: 0.1),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Image.network(
                    category.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      category.icon,
                      size: 40,
                      color: category.color,
                    ),
                  ),
                ),
              ),
            ),
            // Category Label
            Expanded(
              flex: 1,
              child: Center(
                child: Text(
                  category.name.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}