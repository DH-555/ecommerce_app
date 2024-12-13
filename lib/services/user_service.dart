import 'package:appwrite/appwrite.dart';
import 'package:ecommerce_app/providers/appwrite_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../constants/app_constants.dart';

class UserService {
  final Databases databases;
  final Account account;

  UserService({required this.databases, required this.account});

  // Get current user's data from the Users collection
  Future<UserModel> getUserData(String userId) async {
    try {
      // Fetch user document from Appwrite
      final response = await databases.getDocument(
        databaseId: AppConstants.databaseId,
        collectionId: AppConstants.usersCollection,
        documentId: userId,
      );

      // Debug print response
      print('Document data: ${response.toMap()}');

      // Check if the 'data' key exists in the response and parse it into a UserModel
      if (response.toMap().containsKey('data')) {
        return UserModel.fromJson(response.toMap()['data']);
      } else {
        throw Exception('User data not found');
      }
    } catch (e) {
      print('Error in getUserData: $e');
      throw Exception('Failed to fetch user data: $e');
    }
  }

  // Update user's profile data
  Future<UserModel> updateUserData({
    required String userId,
    required String name,
    required String email,
    String? phone,
    String? address,
  }) async {
    try {
      final updatedData = {
        'name': name,
        'email': email,
        'phone': phone,
        'address': address,
      };

      // Update the user document in the Appwrite database
      await databases.updateDocument(
        databaseId: AppConstants.databaseId,
        collectionId: AppConstants.usersCollection,
        documentId: userId,
        data: updatedData,
      );

      // Fetch and return the updated user data
      return getUserData(userId);
    } catch (e) {
      print('Error in updateUserData: $e');
      throw Exception('Failed to update user data: $e');
    }
  }
}

// Define userServiceProvider to access UserService
final userServiceProvider = Provider<UserService>((ref) {
  final databases = ref.watch(appwriteDatabaseProvider);
  final account = ref.watch(appwriteAccountProvider);
  return UserService(databases: databases, account: account);
});
