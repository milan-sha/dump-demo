import 'dart:developer';
import 'package:hive_ce_flutter/hive_flutter.dart';
import '../models/hive_products.dart';

/// Mixin providing Hive storage capabilities across the app.
mixin class StorageServiceMixin {
  static late Box<Product> productBox;
  static late Box userBox;
  static late Box mainBox;

  static const String _productBoxName = 'products';
  static const String _userBoxName = 'userBox';
  static const String _mainBoxName = 'localData';

  /// Initializes Hive, registers adapters, and opens necessary boxes.
  /// Should be called in main.dart before runApp().
  static Future<void> initHive() async {
    try {
      await Hive.initFlutter();

      // Register the Product Adapter (typeId: 1 from your hive_products.dart)
      // Ensure the ProductAdapter in hive_products.g.dart has 7 fields (0-6)
      if (!Hive.isAdapterRegistered(1)) {
        Hive.registerAdapter(ProductAdapter());
      }

      // Open boxes and assign them to static variables
      productBox = await Hive.openBox<Product>(_productBoxName);
      userBox = await Hive.openBox(_userBoxName);
      mainBox = await Hive.openBox(_mainBoxName);

      log("Hive initialized successfully.");
    } catch (e) {
      log("Error initializing Hive: $e");
      // Rethrow to prevent the app from starting with uninitialized boxes
      rethrow;
    }
  }

  // --- PRODUCT HELPERS ---

  /// Returns all products currently stored in the Hive box.
  List<Product> getHiveProducts() => productBox.values.toList();

  /// Returns a single product by its ID
  Product? getProductByIdFromHive(int id) {
    return productBox.values.where((p) => p.id == id).firstOrNull;
  }

  /// Clears and updates the box with new products from the API.
  Future<void> syncProductsToHive(List<Product> products) async {
    try {
      await productBox.clear();
      // Using putAll with ID as key for faster "Call by ID" lookups later
      final Map<int, Product> productMap = {
        for (var p in products) p.id: p
      };
      await productBox.putAll(productMap);

      log("Synced ${products.length} products to Hive.");
    } catch (e) {
      log("Failed to sync products: $e");
    }
  }

  // --- GENERAL DATA HELPERS ---

  /// Generic method to add data to the main configuration box.
  Future<void> addData<T>(MainBoxKeys key, T value) async {
    await mainBox.put(key.name, value);
  }

  /// Generic method to retrieve data from the main configuration box.
  T? getData<T>(MainBoxKeys key) => mainBox.get(key.name) as T?;

  /// Deletes a specific key from the main box.
  Future<void> removeData(MainBoxKeys key) async {
    await mainBox.delete(key.name);
  }
}

/// Keys for general app state storage
enum MainBoxKeys {
  category,
  product,
  cartProducts,
  lastSyncTimestamp,
  isLoggedIn
}