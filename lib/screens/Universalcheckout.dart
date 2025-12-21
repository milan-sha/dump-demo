// lib/screens/universal_checkout.dart
import 'package:flutter/material.dart';
import 'cart.dart';


class UniversalCheckout extends StatelessWidget {
  final List<CartItem> checkoutItems;

  const UniversalCheckout({super.key, required this.checkoutItems});

  // Calculate the raw total of items
  double get subtotal => checkoutItems.fold(0, (sum, item) => sum + (item.price * item.quantity));

  @override
  Widget build(BuildContext context) {
    const double shipping = 50.0;
    final double total = subtotal + shipping;

    return Scaffold(
      appBar: AppBar(title: const Text("Confirm Order"), elevation: 0),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle("Shipping Address"),
                  const Card(
                    child: ListTile(
                      leading: Icon(Icons.local_shipping, color: Colors.blue),
                      title: Text("Deliver to Home"),
                      subtitle: Text("Sector 5, Flutter City, India"),
                    ),
                  ),
                  const SizedBox(height: 20),

                  _sectionTitle("Order Items"),
                  // Lists either the one item from "Buy Now" or all items from "Cart"
                  ...checkoutItems.map((item) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(item.image, width: 50, height: 50, fit: BoxFit.cover),
                    ),
                    title: Text(item.name),
                    subtitle: Text("Qty: ${item.quantity}"),
                    trailing: Text("₹${(item.price * item.quantity).toStringAsFixed(0)}"),
                  )),

                  const Divider(height: 40),
                  _priceRow("Subtotal", subtotal),
                  _priceRow("Shipping", shipping),
                  _priceRow("Grand Total", total, isBold: true),
                ],
              ),
            ),
          ),
          _buildConfirmButton(context, total),
        ],
      ),
    );
  }

  // --- Helper Methods ---

  Widget _sectionTitle(String title) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
  );

  Widget _priceRow(String label, double amount, {bool isBold = false}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: isBold ? 18 : 16, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        Text("₹${amount.toStringAsFixed(0)}", style: TextStyle(fontSize: isBold ? 18 : 16, fontWeight: isBold ? FontWeight.bold : FontWeight.normal, color: isBold ? Colors.green : Colors.black)),
      ],
    ),
  );

  Widget _buildConfirmButton(BuildContext context, double total) => Container(
    padding: const EdgeInsets.all(20),
    decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]),
    child: SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, padding: const EdgeInsets.all(16)),
          onPressed: () => _finishOrder(context),
          child: Text("Pay ₹${total.toStringAsFixed(0)}", style: const TextStyle(fontSize: 18, color: Colors.white)),
        ),
      ),
    ),
  );

  void _finishOrder(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => AlertDialog(
        title: const Text("Success!"),
        content: const Text("Your order has been placed successfully."),
        actions: [TextButton(onPressed: () => Navigator.popUntil(context, (r) => r.isFirst), child: const Text("Home"))],
      ),
    );
  }
}