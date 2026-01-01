import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Added BLoC import
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'cart/cart.dart';
import 'cart/cart_cubit/cart_cubit.dart'; // Ensure this path matches your project

class UniversalCheckout extends StatefulWidget {
  final List<CartItem> checkoutItems;

  const UniversalCheckout({super.key, required this.checkoutItems});

  @override
  State<UniversalCheckout> createState() => _UniversalCheckoutState();
}

class _UniversalCheckoutState extends State<UniversalCheckout> {
  final _formKey = GlobalKey<FormState>();

  // Form Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  // Delivery Window State
  DateTime? _selectedStartDateTime;
  DateTime? _selectedEndDateTime;

  // --- PRICING LOGIC ---

  double get subtotal =>
      widget.checkoutItems.fold(0, (sum, item) => sum + (item.price * item.quantity));

  // Dynamic Shipping logic
  double get shipping => subtotal < 70 ? 20.0 : 0.0;

  double get total => subtotal + shipping;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  // --- TIME PICKER LOGIC ---
  Future<void> _selectStartSchedule(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
    );

    if (pickedDate == null) return;

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime == null) return;

    final DateTime combined = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    if (combined.isBefore(now)) {
      _showSnackBar("Please select a future time.");
      return;
    }

    setState(() {
      _selectedStartDateTime = combined;
      _selectedEndDateTime = null;
    });
  }

  Future<void> _selectEndSchedule(BuildContext context) async {
    if (_selectedStartDateTime == null) {
      _showSnackBar("Please select a Start Time first.");
      return;
    }

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedStartDateTime!,
      firstDate: _selectedStartDateTime!,
      lastDate: _selectedStartDateTime!.add(const Duration(days: 1)),
    );

    if (pickedDate == null) return;

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
          _selectedStartDateTime!.add(const Duration(hours: 1))),
    );

    if (pickedTime == null) return;

    final DateTime combinedEnd = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    final duration = combinedEnd.difference(_selectedStartDateTime!);

    if (combinedEnd.isBefore(_selectedStartDateTime!)) {
      _showSnackBar("End time cannot be before Start time.");
    } else if (duration.inHours >= 24) {
      _showSnackBar("Delivery window cannot exceed 24 hours.");
    } else {
      setState(() {
        _selectedEndDateTime = combinedEnd;
      });
    }
  }

  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Checkout")),
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
                        keyboardType: TextInputType.emailAddress),
                    _buildTextField(_phoneController, "Phone", Icons.phone,
                        keyboardType: TextInputType.phone),
                    _buildTextField(
                        _addressController, "Shipping Address", Icons.location_on,
                        maxLines: 2),
                    const SizedBox(height: 20),
                    _sectionTitle("Delivery Window (Max 24h)"),
                    _scheduleTile(
                      title: _selectedStartDateTime == null
                          ? "Select Start Time"
                          : DateFormat('MMM d, hh:mm a')
                          .format(_selectedStartDateTime!),
                      subtitle: "Earliest arrival",
                      icon: Icons.access_time,
                      onTap: () => _selectStartSchedule(context),
                      isSelected: _selectedStartDateTime != null,
                    ),
                    const SizedBox(height: 10),
                    _scheduleTile(
                      title: _selectedEndDateTime == null
                          ? "Select End Time"
                          : DateFormat('MMM d, hh:mm a')
                          .format(_selectedEndDateTime!),
                      subtitle: "Latest arrival",
                      icon: Icons.timer_outlined,
                      onTap: () => _selectEndSchedule(context),
                      isSelected: _selectedEndDateTime != null,
                      enabled: _selectedStartDateTime != null,
                    ),
                    const SizedBox(height: 25),
                    _sectionTitle("Order Summary"),
                    ...widget.checkoutItems.map((item) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(item.name,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(
                          "Qty: ${item.quantity} x ₹${item.price.toStringAsFixed(0)}"),
                      trailing: Text(
                          "₹${(item.price * item.quantity).toStringAsFixed(0)}"),
                    )),
                    const Divider(height: 30),
                    _priceRow("Subtotal", subtotal),
                    _priceRow("Shipping", shipping,
                        isFree: shipping == 0, isBold: false),
                    _priceRow("Grand Total", total, isBold: true),
                    if (shipping > 0)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          "Add ₹${(70 - subtotal).toStringAsFixed(0)} more for FREE delivery!",
                          style: const TextStyle(
                              color: Colors.orange,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          _buildPayButton(context, total),
        ],
      ),
    );
  }

  // --- UI WIDGET HELPERS ---

  Widget _sectionTitle(String title) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Text(title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
  );

  Widget _buildTextField(TextEditingController controller, String label, IconData icon,
      {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, size: 20),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        validator: (value) =>
        (value == null || value.isEmpty) ? "Field required" : null,
      ),
    );
  }

  Widget _scheduleTile(
      {required String title,
        required String subtitle,
        required IconData icon,
        required VoidCallback onTap,
        bool isSelected = false,
        bool enabled = true}) {
    return InkWell(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: enabled ? Colors.white : Colors.grey.shade100,
          border: Border.all(
              color: isSelected ? Colors.blue : Colors.grey.shade300, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? Colors.blue : Colors.grey),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: enabled ? Colors.black : Colors.grey)),
                    Text(subtitle,
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade600)),
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _priceRow(String label, double amount,
      {bool isBold = false, bool isFree = false}) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(label,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(isFree ? "FREE" : "₹${amount.toStringAsFixed(0)}",
              style: TextStyle(
                  fontSize: 16,
                  color: isFree ? Colors.green : Colors.black,
                  fontWeight: (isBold || isFree) ? FontWeight.bold : FontWeight.normal)),
        ]),
      );

  Widget _buildPayButton(BuildContext context, double total) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5))
        ]),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 55),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          if (_selectedStartDateTime == null || _selectedEndDateTime == null) {
            _showSnackBar("Please select your delivery window.");
            return;
          }
          _confirmPayment(context, total);
        }
      },
      child: Text("Pay ₹${total.toStringAsFixed(0)}",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    ),
  );

  void _confirmPayment(BuildContext context, double total) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.green, size: 60),
            const SizedBox(height: 16),
            const Text("Ready to Place Order?",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Total amount: ₹${total.toStringAsFixed(0)}"),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 50)),
              onPressed: () {
                Navigator.pop(context); // Close sheet
                _completeOrder(context);
              },
              child:
              const Text("Confirm & Pay", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
  void _completeOrder(BuildContext context) {
    // FIXED: Instead of manually clearing a list, call the Cubit
    context.read<CartCubit>().clearCart();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Order Success!"),
        content: const Text(
            "Your items are on the way. Check your email for details."),
        actions: [
          TextButton(
              onPressed: () => context.go('/home'),
              child: const Text("Back to Home")),
        ],
      ),
    );
  }
}