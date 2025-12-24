import 'package:dump/routes.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/adapters.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //

  // Initialize Hive for Flutter
  await Hive.initFlutter(); //

  // Open the box to store user credentials
  await Hive.openBox('userBox'); //

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Dump',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      ),
      routerConfig: appRouter,
    );
  }
}