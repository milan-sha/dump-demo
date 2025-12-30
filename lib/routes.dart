import 'package:dump/screens/cart.dart';
import 'package:dump/screens/main.dart';
import 'package:dump/screens/product_details.dart';
import 'package:dump/screens/products.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/login/login.dart';
import 'screens/product_list_by_category.dart';
import 'screens/universalcheckout/Universalcheckout.dart';
// 1. IMPORT YOUR CALENDAR SCREEN HERE
// import 'package:dump/screens/calendar_page.dart';

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
          builder: (context, state) => const SizedBox(),
        ),
        GoRoute(
          path: '/category',
          builder: (context, state) => const SizedBox(),
        ),
        GoRoute(
          path: '/cart',
          builder: (context, state) => const SizedBox(),
        ),
        GoRoute(
          path: '/account',
          builder: (context, state) => const SizedBox(),
        ),
      ],
    ),

    // 2. ADD THE CALENDAR ROUTE
    GoRoute(
      path: '/calendar',
      builder: (context, state) => const CalendarPage(), // Ensure this class exists
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

// Basic Placeholder for CalendarPage if you haven't created the file yet
class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Calendar")),
      body: const Center(child: Text("Calendar Screen")),
    );
  }
}