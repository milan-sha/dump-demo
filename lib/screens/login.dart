import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_ce/hive_ce.dart'; //

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginPageState();
}

class _LoginPageState extends State<Login> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (formKey.currentState!.validate()) {
      // SAVE TO HIVE
      var box = Hive.box('userBox');
      box.put('username', emailController.text);
      box.put('password', passwordController.text);

      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),
                  const Text("Welcome back", textAlign: TextAlign.center, style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: "EMAIL", border: UnderlineInputBorder()),
                    validator: (value) => value == null || value.isEmpty ? 'Enter email' : null,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: passwordController,
                    obscureText: !isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: "PASSWORD",
                      border: const UnderlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                        onPressed: () => setState(() => isPasswordVisible = !isPasswordVisible),
                      ),
                    ),
                    validator: (value) => value == null || value.isEmpty ? 'Enter password' : null,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text("Login", style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                  // ... rest of your social buttons and register link
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}