import 'package:dump/screens/cart/cart_cubit/cart_cubit.dart';
import 'package:dump/service/storage _service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Required for BlocProvider
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