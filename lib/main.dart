
import 'package:flutter/material.dart';
import 'screens/login.dart';

void main() => runApp(const MainApp());

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dump',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        useMaterial3: false,
      ),
      home: const Login(),
      debugShowCheckedModeBanner: false,
    );
  }
}