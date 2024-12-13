import 'package:appwrite/appwrite.dart';
import '../constants/app_constants.dart';
import '../models/user_model.dart';

class AuthService {
  final Account account;
  final Databases databases;

  AuthService({required this.account, required this.databases});

  // Sign up method
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final result = await account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: name,
      );

      final user = UserModel.fromJson(result.toMap());

      // Save additional user data to database
      await databases.createDocument(
        databaseId: AppConstants.databaseId,
        collectionId: AppConstants.usersCollection,
        documentId: user.id,
        data: user.toJson(),
      );

      return user;
    } catch (e) {
      throw Exception('Failed to sign up: $e');
    }
  }

  // Login method
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      await account.createEmailPasswordSession(
        email: email,
        password: password,
      );
      return getCurrentUser();
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  // Logout method
  Future<void> logout() async {
    try {
      await account.deleteSession(sessionId: 'current');
    } catch (e) {
      throw Exception('Failed to logout: $e');
    }
  }

  // Get the current authenticated user
  Future<UserModel> getCurrentUser() async {
    try {
      final result = await account.get();
      return UserModel.fromJson(result.toMap());
    } catch (e) {
      throw Exception('Failed to get current user: $e');
    }
  }

  // Get current user ID
  Future<String> getCurrentUserId() async {
    try {
      final user = await getCurrentUser();  // Fetch the current user
      return user.id;  // Return the user ID
    } catch (e) {
      throw Exception('Failed to get current user ID: $e');
    }
  }
}



/*import 'package:appwrite/appwrite.dart';
import '../constants/app_constants.dart';
import '../models/user_model.dart';

class AuthService {
  final Account _account;
  final Databases _databases;

  AuthService({required Account account, required Databases databases})
      : _account = account,
        _databases = databases;

  // Sign up method
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      // Create user account
      final accountResult = await _account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: name,
      );

      // Create session after account creation
      await _account.createEmailPasswordSession(
        email: email,
        password: password,
      );

      final user = UserModel.fromJson(accountResult.toMap());

      // Save user data to the database
      await _databases.createDocument(
        databaseId: AppConstants.databaseId,
        collectionId: AppConstants.usersCollection,
        documentId: user.id,
        data: user.toJson(),
      );

      return user;
    } catch (error) {
      throw Exception('Sign-up failed: $error');
    }
  }

  // Login method
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      // Create session for the user
      await _account.createEmailPasswordSession(
        email: email,
        password: password,
      );
      return getCurrentUser();
    } catch (error) {
      throw Exception('Login failed: $error');
    }
  }

  // Logout method
  Future<void> logout() async {
    try {
      // Delete the current session
      await _account.deleteSession(sessionId: 'current');
    } catch (error) {
      throw Exception('Logout failed: $error');
    }
  }

  // Get the current authenticated user
  Future<UserModel> getCurrentUser() async {
    try {
      final result = await _account.get();
      return UserModel.fromJson(result.toMap());
    } catch (error) {
      throw Exception('Failed to fetch current user: $error');
    }
  }

  // Get current user ID
  Future<String> getCurrentUserId() async {
    try {
      final user = await getCurrentUser();
      return user.id;
    } catch (error) {
      throw Exception('Failed to fetch current user ID: $error');
    }
  }
}*/