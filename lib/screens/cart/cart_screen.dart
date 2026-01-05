import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'cart.dart';
import 'cart_cubit/cart_cubit.dart';
import 'cart_cubit/cart_state.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("My Shopping Bag",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state is CartLoaded && state.items.isNotEmpty) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      final item = state.items[index];
                      return _buildCartItem(context, item);
                    },
                  ),
                ),
                _buildOrderSummary(context, state),
              ],
            );
          }
          // If cart is empty or in initial state
          return _buildEmptyState(context);
        },
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, CartItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
                color: Colors.blue[50], borderRadius: BorderRadius.circular(15)),
            child: const Icon(Icons.shopping_bag_outlined, color: Colors.blue),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                Text("₹${item.price}",
                    style: const TextStyle(
                        fontWeight: FontWeight.w900, color: Colors.blue)),
              ],
            ),
          ),
          // QUANTITY CONTROLS
          Row(
            children: [
              // Decrement button
              _qtyBtn(Icons.remove, () => context.read<CartCubit>().removeOneFromCart(item)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text("${item.quantity}",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              // Increment button (reusing addToCart logic)
              _qtyBtn(Icons.add, () => context.read<CartCubit>().addToCart(item)),
            ],
          )
        ],
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
            color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, size: 20, color: Colors.black),
      ),
    );
  }

  Widget _buildOrderSummary(BuildContext context, CartLoaded state) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20)],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total Amount",
                  style: TextStyle(color: Colors.grey[600], fontSize: 16)),
              Text("₹${state.subtotal}",
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
              ),
              onPressed: () {
                // 1. Navigate to your checkout screen
                context.push('/checkout', extra: state.items);

                // 2. CLEAR THE CART
                // We clear it here so that when the user comes back from checkout, the bag is fresh.
                context.read<CartCubit>().clearCart();
              },
              child: const Text("Checkout Now",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_basket_outlined, size: 100, color: Colors.grey[300]),
          const SizedBox(height: 20),
          const Text("Your bag is empty",
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}