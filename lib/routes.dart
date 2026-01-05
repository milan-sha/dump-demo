import 'package:dump/screens/cart/cart.dart';
import 'package:dump/screens/cart/cart_screen.dart';
import 'package:dump/screens/category/category.dart';
import 'package:dump/screens/category/product_list_by_category.dart';
import 'package:go_router/go_router.dart';
import 'models/hive_products.dart';
import 'screens/login/login.dart';
import 'screens/home/home.dart'; // Updated path for the new folder
import 'screens/account/account.dart';
import 'screens/product_details.dart';
import 'screens/checkout/universalcheckout.dart';
import 'screens/main.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const Login(),
    ),

    // Main App Shell (Contains Bottom Navigation)
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
        // ADDED: Cart route inside the Shell
        GoRoute(
          path: '/cart',
          builder: (context, state) => CartScreen(),
        ),
        GoRoute(
          path: '/account',
          builder: (context, state) => const AccountScreen(),
        ),
      ],
    ),

    // Full-screen routes (No Bottom Bar)
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
        // Items passed from CartScreen or ProductDetailScreen
        final items = state.extra as List<CartItem>;
        return UniversalCheckout(checkoutItems: items);
      },
    ),
  ],
);