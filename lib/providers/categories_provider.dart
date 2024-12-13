// providers/categories_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommerce_app/services/category_service.dart';
import 'package:ecommerce_app/models/category_model.dart';

final categoriesProvider = FutureProvider<List<CategoryModel>>((ref) async {
  final categoryService = CategoryService();
  return await categoryService.fetchCategories();
});