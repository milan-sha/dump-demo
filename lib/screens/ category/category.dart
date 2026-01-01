import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'category_cubit/category_cubit.dart';
import 'category_cubit/category_state.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CategoryCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Explore Categories", style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: BlocBuilder<CategoryCubit, CategoryState>(
          builder: (context, state) {
            if (state is CategoryLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is CategoryLoaded) {
              return GridView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.categories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.85,
                ),
                itemBuilder: (context, index) {
                  final category = state.categories[index];
                  return _CategoryCard(category: category);
                },
              );
            }

            if (state is CategoryError) {
              return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final dynamic category;
  const _CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/category-products', extra: category.name),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: category.color.withOpacity(0.1),
          border: Border.all(color: category.color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 35,
              backgroundColor: category.color,
              child: Icon(category.icon, color: Colors.white, size: 30),
            ),
            const SizedBox(height: 12),
            Text(
              category.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}