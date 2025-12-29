import 'package:dump/screens/cart.dart';
import 'package:dump/screens/main.dart';
import 'package:dump/screens/product_details.dart';
import 'package:dump/screens/products.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/login/login.dart';
import 'screens/product_list_by_category.dart';
import 'screens/universalcheckout/Universalcheckout.dart';


final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const Login(),
    ),

    // ShellRoute for MainScreen tabs
    ShellRoute(
      builder: (context, state, child) {
        return MainScreen(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const SizedBox(), // Home tab handled in MainScreen
        ),
        GoRoute(
          path: '/category',
          builder: (context, state) => const SizedBox(), // Category tab handled in MainScreen
        ),
        GoRoute(
          path: '/cart',
          builder: (context, state) => const SizedBox(), // Cart tab handled in MainScreen
        ),
        GoRoute(
          path: '/account',
          builder: (context, state) => const SizedBox(), // Account tab handled in MainScreen
        ),
      ],
    ),

    // Category Products page
    GoRoute(
      path: '/category-products',
      builder: (context, state) {
        final categoryName = state.extra as String;
        return ProductListByCategoryPage(categoryName: categoryName);
      },
    ),

    // Product Detail page
    GoRoute(
      path: '/product-detail',
      builder: (context, state) {
        final product = state.extra as Product;
        return ProductDetailScreen(product: product);
      },
    ),

    // Checkout page
    GoRoute(
      path: '/checkout',
      builder: (context, state) {
        final items = state.extra as List<CartItem>;
        return UniversalCheckout(checkoutItems: items);
      },
    ),
  ],
);