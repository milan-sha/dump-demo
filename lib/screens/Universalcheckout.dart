// lib/screens/universal_checkout.dart
import 'package:flutter/material.dart';
import 'cart.dart';


class UniversalCheckout extends StatefulWidget {
  final List<CartItem> checkoutItems;

  const UniversalCheckout({super.key, required this.checkoutItems});

  @override
  State<UniversalCheckout> createState() => _UniversalCheckoutState();
}

class _UniversalCheckoutState extends State<UniversalCheckout> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  double get subtotal =>
      widget.checkoutItems.fold(0, (sum, item) => sum + (item.price * item.quantity));

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  // Email validation RegExp
  bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
        r"^[a-zA-Z0-9]+([._%+-]?[a-zA-Z0-9])*@[a-zA-Z0-9-]+(\.[a-zA-Z]{2,})+$"
    );
    return emailRegex.hasMatch(email);
  }

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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle("Personal Details"),
                    _buildTextField(_nameController, "Full Name", Icons.person),
                    _buildTextField(_emailController, "Email", Icons.email,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your email";
                          } else if (!isValidEmail(value)) {
                            return "Enter a valid email";
                          }
                          return null;
                        }),
                    _buildTextField(_phoneController, "Phone Number", Icons.phone,
                        keyboardType: TextInputType.phone),
                    _buildTextField(_addressController, "Shipping Address", Icons.location_on,
                        maxLines: 3),
                    const SizedBox(height: 20),
                    _sectionTitle("Order Items"),
                    ...widget.checkoutItems.map(
                          (item) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(item.image,
                              width: 50, height: 50, fit: BoxFit.cover),
                        ),
                        title: Text(item.name),
                        subtitle: Text("Qty: ${item.quantity}"),
                        trailing: Text("₹${(item.price * item.quantity).toStringAsFixed(0)}"),
                      ),
                    ),
                    const Divider(height: 40),
                    _priceRow("Subtotal", subtotal),
                    _priceRow("Shipping", shipping),
                    _priceRow("Grand Total", total, isBold: true),
                  ],
                ),
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
    child: Text(title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
  );

  Widget _buildTextField(TextEditingController controller, String label,
      IconData icon,
      {int maxLines = 1,
        TextInputType keyboardType = TextInputType.text,
        String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
        ),
        validator: validator ??
                (value) {
              if (value == null || value.trim().isEmpty) {
                return "Please enter $label";
              }
              return null;
            },
      ),
    );
  }

  Widget _priceRow(String label, double amount, {bool isBold = false}) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: TextStyle(
                    fontSize: isBold ? 18 : 16,
                    fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
            Text("₹${amount.toStringAsFixed(0)}",
                style: TextStyle(
                    fontSize: isBold ? 18 : 16,
                    fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                    color: isBold ? Colors.green : Colors.black)),
          ],
        ),
      );

  Widget _buildConfirmButton(BuildContext context, double total) =>
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange, padding: const EdgeInsets.all(16)),
              onPressed: () => _showVerificationSheet(context),
              child: Text("Pay ₹${total.toStringAsFixed(0)}",
                  style: const TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ),
        ),
      );

  // --- Creative Verification Bottom Sheet ---
  void _showVerificationSheet(BuildContext context) {
    if (_formKey.currentState?.validate() != true) return;

    const double shipping = 50.0;
    final double total = subtotal + shipping;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
          ),
          padding: const EdgeInsets.all(20),
          child: ListView(
            controller: controller,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(5)),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Verify Your Details",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _infoRow("Name", _nameController.text),
                      _infoRow("Email", _emailController.text),
                      _infoRow("Phone", _phoneController.text),
                      _infoRow("Address", _addressController.text),
                      _infoRow("Total", "₹${total.toStringAsFixed(0)}"),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // close bottom sheet
                  _showSuccessDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text(
                  "Confirm Order",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 80, child: Text("$label:", style: const TextStyle(fontWeight: FontWeight.bold))),
        Expanded(child: Text(value)),
      ],
    ),
  );

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Success!"),
        content: Text(
            "Thank you ${_nameController.text}!\n\nYour order will be delivered to:\n${_addressController.text}"),
        actions: [
          TextButton(
              onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
              child: const Text("Home"))
        ],
      ),
    );
  }
}
