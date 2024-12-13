import 'package:ecommerce_app/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';
import '../services/auth_service.dart';

// Define userProvider to manage user-related state
final userProvider = StateNotifierProvider<UserNotifier, UserModel?>((ref) {
  final userService = ref.watch(userServiceProvider);
  final authService = ref.watch(authServiceProvider);
  return UserNotifier(userService: userService, authService: authService);
});

class UserNotifier extends StateNotifier<UserModel?> {
  final UserService userService;
  final AuthService authService;

  UserNotifier({required this.userService, required this.authService}) : super(null);

  // Fetch the current user's data from the service
  Future<void> fetchUserData() async {
    try {
      final userId = await authService.getCurrentUserId();
      print('Fetched user ID: $userId');
      final user = await userService.getUserData(userId);
      print('Fetched user data: ${user.name}, ${user.email}, ${user.phone}, ${user.address}');
      state = user; // Update the state with the fetched user data
    } catch (e) {
      print('Error in fetchUserData: $e');
      state = null; // Reset state if an error occurs
    }
  }

  // Update user's profile data
  Future<void> updateUserProfile({
    required String name,
    required String email,
    String? phone,
    String? address,
  }) async {
    try {
      final userId = await authService.getCurrentUserId();
      final updatedUser = await userService.updateUserData(
        userId: userId,
        name: name,
        email: email,
        phone: phone,
        address: address,
      );
      state = updatedUser; // Update the state with the new user data
      print('Updated user data: ${updatedUser.name}, ${updatedUser.email}');
    } catch (e) {
      print('Error in updateUserProfile: $e');
      throw Exception('Failed to update profile: $e');
    }
  }
}

