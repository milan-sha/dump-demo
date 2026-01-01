import 'package:dump/service/storage%20_service.dart';
import 'package:flutter/material.dart';
import 'routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize your storage and products
  await StorageServiceMixin.initHive();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter, // Uses your GoRouter from routes.dart
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}