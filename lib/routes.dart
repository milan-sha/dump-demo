import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// Model & Cubit Imports
import 'models/product.dart';
import 'screens/home/home_cubit/home_cubit.dart';
import 'screens/cart/cart.dart';

// Screen Imports
import 'screens/login/login.dart';
import 'screens/home/home.dart';
import 'screens/category/category.dart';
import 'screens/category/product_list.dart';
import 'screens/cart/cart_screen.dart';
import 'screens/account/account.dart';
import 'screens/product_details.dart';
import 'screens/product_details_loader.dart';
import 'screens/checkout/universalcheckout.dart';
import 'screens/main.dart';



final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    // --- Login Route ---
    GoRoute(
      path: '/login',
      builder: (context, state) => const Login(),
    ),

    // --- Main App Shell (Contains Bottom Navigation) ---
    ShellRoute(
      builder: (context, state, child) {
        return MainScreen(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/category',
          builder: (context, state) => const CategoryScreen(),
        ),
        GoRoute(
          path: '/cart',
          builder: (context, state) => const CartScreen(),
        ),
        GoRoute(
          path: '/account',
          builder: (context, state) => const AccountScreen(),
        ),
      ],
    ),

    // --- Full-screen routes (No Bottom Bar) ---

    // 1. Category Products
    GoRoute(
      path: '/category-products',
      builder: (context, state) {
        final categoryName = state.extra as String;
        return ProductListByCategoryPage(categoryName: categoryName);
      },
    ),

    // 2. Product Detail (Via Object Passing - Current Method)
    GoRoute(
      path: '/product-detail',
      builder: (context, state) {
        if (state.extra is Product) {
          return ProductDetailScreen(product: state.extra as Product);
        }
        // Fallback if someone navigates here without the object
        return const Scaffold(body: Center(child: Text("Invalid Product Data")));
      },
    ),

    // 3. Product Detail (Via ID - For "Call by ID" or Deep Linking)
    // Usage: context.push('/product/15')
    GoRoute(
      path: '/product/:id',
      builder: (context, state) {
        final idString = state.pathParameters['id'];
        final id = int.tryParse(idString ?? '');

        if (id == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text("Invalid product ID")),
          );
        }

        // Try to find product from the Cubit's state first
        final product = context.read<HomeCubit>().getProductById(id);

        if (product != null) {
          return ProductDetailScreen(product: product);
        } else {
          // If not found in state, fetch from API
          return ProductDetailLoader(productId: id);
        }
      },
    ),

    // 4. Checkout
    GoRoute(
      path: '/checkout',
      builder: (context, state) {
        final items = state.extra as List<CartItem>;
        return UniversalCheckout(checkoutItems: items);
      },
    ),
  ],
);