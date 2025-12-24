import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Category {
  final String name;
  final String image;
  final Color color;
  final IconData icon;

  Category({
    required this.name,
    required this.image,
    required this.color,
    required this.icon,
  });
}

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      Category(
        name: 'Shoes',
        image: 'assets/grpshoes.jpg',
        color: Colors.blue,
        icon: Icons.directions_run,
      ),
      Category(
        name: 'Fashion',
        image: 'assets/greenbag.jpg',
        color: Colors.pink,
        icon: Icons.checkroom,
      ),
      Category(
        name: 'Cosmetics',
        image: 'assets/cosmetics.jpg',
        color: Colors.green,
        icon: Icons.brush,
      ),
      Category(
        name: 'Furniture',
        image: 'assets/grpfurn.jpg',
        color: Colors.orange,
        icon: Icons.chair_alt,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Explore Categories")),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: categories.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: 0.9),
        itemBuilder: (context, index) {
          final category = categories[index];
          return GestureDetector(
            onTap: () => context.push('/category-products', extra: category.name),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(category.image, fit: BoxFit.cover),
                ),
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Text(category.name,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}