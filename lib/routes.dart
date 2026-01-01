import 'package:dump/screens/%20category/category.dart';
import 'package:dump/screens/cart.dart';
import 'package:dump/screens/universalcheckout.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'models/hive_products.dart';
import 'screens/login/login.dart';
import 'screens/home/home.dart';

import 'screens/account/account.dart';
import 'screens/product_details.dart';
import 'screens/product_list_by_category.dart';
import 'screens/main.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const Login(),
    ),
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
          path: '/account',
          builder: (context, state) => const AccountScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/category-products',
      builder: (context, state) {
        final categoryName = state.extra as String;
        return ProductListByCategoryPage(categoryName: categoryName);
      },
    ),
    GoRoute(
      path: '/product-detail',
      builder: (context, state) {
        final product = state.extra as Product;
        return ProductDetailScreen(product: product);
      },
    ),
    GoRoute(
      path: '/checkout',
      builder: (context, state) {
        final items = state.extra as List<CartItem>;
        return UniversalCheckout(checkoutItems: items);
      },
    ),
  ],
);