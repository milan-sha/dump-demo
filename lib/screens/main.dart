import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'account/account.dart';
import 'cart/cart_cubit/cart_cubit.dart';
import 'cart/cart_screen.dart';
import 'category/category.dart';
import 'home/home.dart';

class MainScreen extends StatefulWidget {
  final Widget child;
  const MainScreen({super.key, required this.child});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // Screens preserved in an IndexedStack to maintain scroll positions
  late final List<Widget> _screens = [
    const HomePage(),
    const CategoryScreen(),
    const CartScreen(), // Ensure CartScreen is const if possible
    const AccountScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack prevents the screens from rebuilding when switching tabs
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12, left: 24, right: 24),
          child: Container(
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                )
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.transparent,
                elevation: 0,
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
                selectedItemColor: Colors.blue,
                unselectedItemColor: Colors.grey,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                items: [
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined),
                    activeIcon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.grid_view_outlined),
                    activeIcon: Icon(Icons.grid_view),
                    label: 'Category',
                  ),
// Inside your MainScreen building the Badge:
                  BottomNavigationBarItem(
                    icon: BlocBuilder<CartCubit, CartState>(
                      // Changed .cartItems to .items to match your likely Cubit state
                      buildWhen: (previous, current) => previous.items != current.items,
                      builder: (context, state) {
                        // Calculate total quantity from state.items
                        int count = state.items.fold(0, (sum, item) => sum + item.quantity);

                        return Badge(
                          label: Text('$count'),
                          isLabelVisible: count > 0,
                          backgroundColor: Colors.red,
                          child: const Icon(Icons.shopping_cart_outlined),
                        );
                      },
                    ),
                    activeIcon: const Icon(Icons.shopping_cart),
                    label: 'Cart',
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.person_outline),
                    activeIcon: Icon(Icons.person),
                    label: 'Account',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}