import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appwrite/appwrite.dart';
import '../constants/app_constants.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

// Provider to access Appwrite Client
final appwriteClientProvider = Provider((ref) {
  Client client = Client();
  return client
    .setEndpoint(AppConstants.endpoint)
    .setProject(AppConstants.projectId);
});

// Provider to access AuthService
final authServiceProvider = Provider<AuthService>((ref) {
  final client = ref.watch(appwriteClientProvider);
  return AuthService(
    account: Account(client),
    databases: Databases(client),
  );
});

// StateNotifierProvider for managing authentication state
final authStateProvider = StateNotifierProvider<AuthNotifier, AsyncValue<UserModel?>>((ref) {
  return AuthNotifier(ref.watch(authServiceProvider));
});

// Auth Notifier to handle authentication-related state
class AuthNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(const AsyncValue.loading()) {
    getCurrentUser();
  }

  // Get current user and update state
  Future<void> getCurrentUser() async {
    try {
      final user = await _authService.getCurrentUser();
      state = AsyncValue.data(user);
    } catch (e) {
      state = const AsyncValue.data(null); // Set to null if no user is found
    }
  }

  // Sign up and update state
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    state = const AsyncValue.loading();
    try {
      final user = await _authService.signUp(
        email: email,
        password: password,
        name: name,
      );
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  // Login and update state
  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    try {
      final user = await _authService.login(
        email: email,
        password: password,
      );
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  // Logout and reset state
  Future<void> logout() async {
    await _authService.logout();
    state = const AsyncValue.data(null);
  }
}
