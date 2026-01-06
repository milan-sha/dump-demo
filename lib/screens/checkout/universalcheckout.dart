import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../cart/cart_cubit/cart_cubit.dart';
import 'chekout_cubit/checkout_cubit.dart';


class UniversalCheckout extends StatefulWidget {
  final List<dynamic> checkoutItems; // Use your CartItem model here

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

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  double get subtotal => widget.checkoutItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
  double get shipping => subtotal < 70 ? 20.0 : 0.0;
  double get total => subtotal + shipping;

  // --- MISSING UI HELPER METHODS ADDED BELOW ---

  Widget _sectionTitle(String title) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
  );

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (value) => (value == null || value.isEmpty) ? "Required" : null,
      ),
    );
  }


  Widget _priceRow(String label, double amount, {bool isBold = false, bool isFree = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 16, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        Text(isFree ? "FREE" : "₹${amount.toStringAsFixed(0)}", style: TextStyle(fontSize: 16, color: isFree ? Colors.green : Colors.black, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
      ],
    );
  }

  Widget _buildPayButton(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.black, minimumSize: const Size(double.infinity, 55)),
      onPressed: () => _confirmPayment(context),
      child: Text("Pay ₹${total.toStringAsFixed(0)}", style: const TextStyle(color: Colors.white)),
    ),
  );

  void _confirmPayment(BuildContext context) {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    context.read<CheckoutCubit>().saveDetails(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      address: _addressController.text.trim(),
      items: widget.checkoutItems,
      total: total,
    );

    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Confirm Order", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                context.read<CheckoutCubit>().processCheckout();
              },
              child: const Text("Confirm & Pay"),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CheckoutCubit(),
      child: BlocListener<CheckoutCubit, CheckoutState>(
        listener: (context, state) {
          if (state.checkoutStatus == CheckoutStatus.success) {
            context.read<CartCubit>().clearCart();
            context.go('/home');
          }
        },
        child: Scaffold(
          appBar: AppBar(title: const Text("Checkout")),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: BlocBuilder<CheckoutCubit, CheckoutState>(
                      builder: (context, state) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _sectionTitle("Personal Details"),
                            _buildTextField(_nameController, "Full Name", Icons.person),
                            _buildTextField(_emailController, "Email", Icons.email),
                            _buildTextField(_phoneController, "Phone Number", Icons.phone, keyboardType: TextInputType.phone),
                            _buildTextField(_addressController, "Address", Icons.home, maxLines: 3),
                            _sectionTitle("Order Summary"),
                            _priceRow("Grand Total", total, isBold: true),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
              _buildPayButton(context),
            ],
          ),
        ),
      ),
    );
  }
}