import 'package:dump/screens/cart/cart_cubit/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Required for BlocProvider
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'routes.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive only for user data storage (not for products)
  await Hive.initFlutter();
  
  // Open the userBox for login/account functionality
  await Hive.openBox('userBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Wrap the app in MultiBlocProvider so the Cart state lives at the top level
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CartCubit(),
        ),
        // You can add other global cubits here later (e.g., ThemeCubit, UserCubit)
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter, // Uses your GoRouter from routes.dart
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true, // Recommended for modern Flutter UI
        ),
      ),
    );
  }
}