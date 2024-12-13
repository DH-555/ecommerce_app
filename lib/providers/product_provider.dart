// lib/core/providers/product_provider.dart

import 'package:appwrite/appwrite.dart';
import 'package:ecommerce_app/providers/appwrite_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/product_service.dart';
import '../models/product_model.dart';

// Provider for ProductService
final productServiceProvider = Provider<ProductService>((ref) {
  final client = ref.watch(appwriteClientProvider);
  return ProductService(databases: Databases(client));
});

// Provider for fetching all products (default behavior)
final productListProvider = FutureProvider<List<ProductModel>>((ref) async {
  final productService = ref.watch(productServiceProvider);
  return productService.getProducts();
});

// Provider for fetching products based on category
final productsByCategoryProvider = FutureProvider.family<List<ProductModel>, String>((ref, category) async {
  final productService = ref.watch(productServiceProvider);
  return productService.getProductsByCategory(category);
});

// Provider for searching products (filtered based on query)
final searchProductProvider = FutureProvider.family<List<ProductModel>, String>((ref, query) async {
  final productService = ref.watch(productServiceProvider);
  return productService.searchProducts(query);
});
