import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:hive_ce_flutter/adapters.dart';
import '../models/hive_products.dart';




mixin class StorageServiceMixin {
  static late Box<Product> productBox;
  static late Box userBox;

  static Future<void> initHive() async {
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(ProductAdapter());
    }
    productBox = await Hive.openBox<Product>('products');
    userBox = await Hive.openBox('userBox');

    if (productBox.isEmpty) {
      await _loadFromAssets();
    }
  }
  static Future<void> _loadFromAssets() async {
    try {
      final String response = await rootBundle.loadString('assets/products.json');
      final List<dynamic> data = json.decode(response);
      final products = data.map((json) => Product.fromJson(json)).toList();
      await productBox.addAll(products);
      log("Successfully loaded ${products.length} products into Hive");
    } catch (e) {
      log("Error loading JSON: $e");
    }
  }
  List<Product> getHiveProducts() => productBox.values.toList();
}
enum MainBoxKeys { category, product ,cartProducts }

mixin class StoragesServiceMixin {
  static late Box? mainBox;
  static const _boxName = 'localData';

  static Future<void> initHive() async {
    await Hive.initFlutter();

    mainBox = await Hive.openBox(_boxName);
  }

  Future<void> addData<T>(MainBoxKeys key, T value) async {
    await mainBox?.put(key.name, value);
  }

  Future<void> removeData(MainBoxKeys key) async {
    await mainBox?.delete(key.name);
  }

  T getData<T>(MainBoxKeys key) => mainBox?.get(key.name) as T;

  Future<void> closeBox() async {
    try {
      if (mainBox != null) {
        await mainBox?.close();
        await mainBox?.deleteFromDisk();
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
