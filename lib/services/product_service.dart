// lib/core/services/product_service.dart

import 'package:appwrite/appwrite.dart';
import '../constants/app_constants.dart';
import '../models/product_model.dart';

class ProductService {
  final Databases databases;

  ProductService({required this.databases});

  // Fetch all products
  Future<List<ProductModel>> getProducts() async {
    try {
      final result = await databases.listDocuments(
        databaseId: AppConstants.databaseId,
        collectionId: AppConstants.productsCollection,
      );
      return result.documents.map((doc) => ProductModel.fromJson(doc.data)).toList();
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }

  // Fetch products based on category
  Future<List<ProductModel>> getProductsByCategory(String category) async {
    try {
      final result = await databases.listDocuments(
        databaseId: AppConstants.databaseId,
        collectionId: AppConstants.productsCollection,
        queries: [
          Query.equal('categories', category), // Filter by category
        ],
      );
      return result.documents.map((doc) => ProductModel.fromJson(doc.data)).toList();
    } catch (e) {
      throw Exception('Failed to fetch products by category: $e');
    }
  }

  // Fetch products based on search query
  Future<List<ProductModel>> searchProducts(String query) async {
    try {
      final result = await databases.listDocuments(
        databaseId: AppConstants.databaseId,
        collectionId: AppConstants.productsCollection,
        queries: [
          Query.search('name', query), // Assuming 'name' is the field to search
        ],
      );
      return result.documents.map((doc) => ProductModel.fromJson(doc.data)).toList();
    } catch (e) {
      throw Exception('Failed to search products: $e');
    }
  }

  // Fetch a single product by ID
  Future<ProductModel> getProduct(String productId) async {
    try {
      final result = await databases.getDocument(
        databaseId: AppConstants.databaseId,
        collectionId: AppConstants.productsCollection,
        documentId: productId,
      );
      return ProductModel.fromJson(result.data);
    } catch (e) {
      throw Exception('Failed to fetch product: $e');
    }
  }
}
