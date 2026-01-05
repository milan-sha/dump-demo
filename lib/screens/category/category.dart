import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Assuming you have a Category model. If not, this matches your UI needs.
class ProductCategory {
  final String name;
  final IconData icon;
  final Color color;

  const ProductCategory({required this.name, required this.icon, required this.color});
}

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  final List<ProductCategory> categories = const [
    ProductCategory(name: 'Sneakers', icon: Icons.directions_run, color: Colors.blue),
    ProductCategory(name: 'Basketball', icon: Icons.sports_basketball, color: Colors.orange),
    ProductCategory(name: 'Running', icon: Icons.timer, color: Colors.green),
    ProductCategory(name: 'Training', icon: Icons.fitness_center, color: Colors.purple),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.1,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return _CategoryCard(
            category: category,
            onTap: () {
              // Navigates to the product list page for this category
              context.push('/category-products', extra: category.name);
            },
          );
        },
      ),
    );
  }
}

// --- FIXED: Added missing _CategoryCard definition ---
class _CategoryCard extends StatelessWidget {
  final ProductCategory category;
  final VoidCallback onTap;

  const _CategoryCard({required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: category.color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: category.color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(category.icon, size: 40, color: category.color),
            const SizedBox(height: 12),
            Text(
              category.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}