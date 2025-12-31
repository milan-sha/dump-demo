import 'package:dump/screens/products.dart';
import 'package:go_router/go_router.dart';
import 'screens/login/login.dart';
import 'screens/home/home.dart';
import 'screens/ category/category.dart';
import 'screens/cart_screen.dart';
import 'screens/account/account.dart';
import 'screens/product_details.dart';
import 'screens/product_list_by_category.dart';
import 'screens/main.dart'; // Ensure this points to your MainScreen


final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    // Login Route
    GoRoute(
      path: '/login',
      builder: (context, state) => const Login(),
    ),

    // ShellRoute for the Bottom Navigation Tabs
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

  ],
);