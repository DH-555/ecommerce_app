import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/cart_service.dart';
import '../models/cart_model.dart';
import '../providers/auth_provider.dart';

final cartServiceProvider = Provider<CartService>((ref) {
  final client = ref.watch(appwriteClientProvider);
  return CartService(databases: Databases(client));
});

final cartProvider = FutureProvider<CartModel>((ref) async {
  final authState = ref.watch(authStateProvider);
  if (authState.value == null) {
    throw Exception('User not logged in');
  }
  final cartService = ref.watch(cartServiceProvider);
  return cartService.getCart(authState.value!.id);
});
