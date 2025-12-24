import 'package:flutter/material.dart';
import 'package:hive_ce/hive_ce.dart'; //
import 'package:go_router/go_router.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // FETCH FROM HIVE
    var box = Hive.box('userBox');
    String savedUser = box.get('username', defaultValue: 'Guest');
    String savedPass = box.get('password', defaultValue: '****');

    return Scaffold(
      appBar: AppBar(title: const Text("Account"), elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Existing Avatar UI
            Stack(
              children: [
                Container(
                  width: 120, height: 120,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.blue, width: 4),
                  ),
                ),
                Positioned(
                  top: 8, left: 8, right: 8, bottom: 8,
                  child: ClipOval(
                    child: Image.asset(
                      'assets/profile.jpg',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        decoration: BoxDecoration(color: Colors.grey.shade300, shape: BoxShape.circle),
                        child: const Icon(Icons.person, size: 50),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Display Stored Data
            Text(
              savedUser,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              "Pass: $savedPass",
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 40),

            _buildSectionTitle("Account"),
            _buildListTile(Icons.person, "Account Information", true),
            _buildListTile(Icons.shopping_bag, "Order History", true),

            const SizedBox(height: 24),
            _buildSectionTitle("Settings"),
            _buildListTile(Icons.notifications, "Notifications", true),
            _buildListTile(Icons.lock, "Privacy Policy", true),

            const SizedBox(height: 32),

            // Logout Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  box.clear(); // Clear local data on logout
                  context.go('/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Logout", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Existing helper methods kept as is
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(width: 4, height: 20, decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 12),
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title, bool showTrailing) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: Colors.blue, size: 24),
        ),
        title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        trailing: showTrailing ? const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey) : null,
      ),
    );
  }
}