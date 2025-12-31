import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../models/cartI_item.dart';

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

  // --- DELIVERY SCHEDULE STATE ---
  DateTime? _selectedStartDateTime;
  DateTime? _selectedEndDateTime; // User-selected end window

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

  // --- START TIME PICKER ---
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
      pickedDate.year, pickedDate.month, pickedDate.day,
      pickedTime.hour, pickedTime.minute,
    );

    if (combined.isBefore(now)) {
      _showSnackBar("Please select a future time.");
      return;
    }

    setState(() {
      _selectedStartDateTime = combined;
      _selectedEndDateTime = null; // Reset end time if start changes
    });
  }

  // --- END TIME PICKER (The 24h Logic) ---
  Future<void> _selectEndSchedule(BuildContext context) async {
    if (_selectedStartDateTime == null) {
      _showSnackBar("Please select a Start Time first.");
      return;
    }

    // Lock the date to only the Start Date or the next day
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedStartDateTime!,
      firstDate: _selectedStartDateTime!,
      lastDate: _selectedStartDateTime!.add(const Duration(days: 1)),
    );

    if (pickedDate == null) return;

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedStartDateTime!.add(const Duration(hours: 1))),
    );

    if (pickedTime == null) return;

    final DateTime combinedEnd = DateTime(
      pickedDate.year, pickedDate.month, pickedDate.day,
      pickedTime.hour, pickedTime.minute,
    );

    // Validation
    final duration = combinedEnd.difference(_selectedStartDateTime!);

    if (combinedEnd.isBefore(_selectedStartDateTime!)) {
      _showSnackBar("End time cannot be before Start time.");
    } else if (duration.inHours >= 24) {
      _showSnackBar("Window cannot exceed 24 hours.");
    } else {
      setState(() {
        _selectedEndDateTime = combinedEnd;
      });
    }
  }

  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  bool isValidEmail(String email) {
    return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    const double shipping = 50.0;
    final double total = subtotal + shipping;

    return Scaffold(
      appBar: AppBar(title: const Text("Confirm Order")),
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
                        validator: (value) => (value == null || !isValidEmail(value)) ? "Enter valid email" : null),
                    _buildTextField(_phoneController, "Phone", Icons.phone, keyboardType: TextInputType.phone),
                    _buildTextField(_addressController, "Shipping Address", Icons.location_on, maxLines: 2),

                    const SizedBox(height: 20),
                    _sectionTitle("Delivery Window (Max 24 Hours)"),

                    // START TIME BOX
                    _scheduleTile(
                      title: _selectedStartDateTime == null ? "Select Start Time" : DateFormat('MMM d, hh:mm a').format(_selectedStartDateTime!),
                      subtitle: "Beginning of delivery window",
                      icon: Icons.start_rounded,
                      onTap: () => _selectStartSchedule(context),
                      isSelected: _selectedStartDateTime != null,
                    ),

                    const SizedBox(height: 10),

                    // END TIME BOX
                    _scheduleTile(
                      title: _selectedEndDateTime == null ? "Select End Time" : DateFormat('MMM d, hh:mm a').format(_selectedEndDateTime!),
                      subtitle: "End of delivery window",
                      icon: Icons.update_rounded,
                      onTap: () => _selectEndSchedule(context),
                      isSelected: _selectedEndDateTime != null,
                      enabled: _selectedStartDateTime != null,
                    ),

                    const SizedBox(height: 20),
                    _sectionTitle("Order Items"),
                    ...widget.checkoutItems.map((item) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Image.asset(item.image, width: 40),
                      title: Text(item.name),
                      trailing: Text("₹${(item.price * item.quantity).toStringAsFixed(0)}"),
                    )),
                    const Divider(height: 30),
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

  Widget _scheduleTile({required String title, required String subtitle, required IconData icon, required VoidCallback onTap, bool isSelected = false, bool enabled = true}) {
    return InkWell(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: enabled ? Colors.white : Colors.grey.shade100,
          border: Border.all(color: isSelected ? Colors.orange : Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: enabled ? Colors.orange : Colors.grey),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: enabled ? Colors.black : Colors.grey)),
                Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
  );

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {int maxLines = 1, TextInputType keyboardType = TextInputType.text, String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon), border: const OutlineInputBorder()),
        validator: validator ?? (v) => (v == null || v.isEmpty) ? "Required" : null,
      ),
    );
  }

  Widget _priceRow(String label, double amount, {bool isBold = false}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
      Text("₹${amount.toStringAsFixed(0)}"),
    ]),
  );

  Widget _buildConfirmButton(BuildContext context, double total) => Container(
    padding: const EdgeInsets.all(20),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, minimumSize: const Size(double.infinity, 50)),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          if (_selectedStartDateTime == null || _selectedEndDateTime == null) {
            _showSnackBar("Please select both Start and End times.");
            return;
          }
          _showVerificationSheet(context);
        }
      },
      child: Text("Pay ₹${total.toStringAsFixed(0)}", style: const TextStyle(color: Colors.white)),
    ),
  );

  void _showVerificationSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Verify Delivery Window", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),
            _infoRow("Deliver to", _addressController.text),
            _infoRow("Starts", DateFormat('MMM d, h:mm a').format(_selectedStartDateTime!)),
            _infoRow("Ends", DateFormat('MMM d, h:mm a').format(_selectedEndDateTime!)),
            _infoRow("Total", "₹${(subtotal + 50).toStringAsFixed(0)}"),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, minimumSize: const Size(double.infinity, 50)),
              onPressed: () => _showSuccessDialog(context),
              child: const Text("Confirm & Pay", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(children: [
      Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
      Expanded(child: Text(value, overflow: TextOverflow.ellipsis)),
    ]),
  );

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Order Placed!"),
        content: Text("Delivering is  ${DateFormat('h:mm a').format(_selectedEndDateTime!)} on ${DateFormat('MMM d').format(_selectedStartDateTime!)}"),
        actions: [TextButton(onPressed: () => context.go('/home'), child: const Text("OK"))],
      ),
    );
  }
}