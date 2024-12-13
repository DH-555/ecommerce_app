// lib/providers/order_provider.dart
import 'package:appwrite/appwrite.dart';
import 'package:ecommerce_app/providers/appwrite_provider.dart';
import 'package:ecommerce_app/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/order_service.dart';
import '../models/order_model.dart';

final orderServiceProvider = Provider<OrderService>((ref) {
  final client = ref.watch(appwriteClientProvider);
  return OrderService(databases: Databases(client));
});

final userOrdersProvider = FutureProvider.family<List<OrderModel>, String>(
  (ref, userId) async {
    final orderService = ref.watch(orderServiceProvider);
    return orderService.getUserOrders(userId);
  },
);

final orderProvider = FutureProvider.family<OrderModel, String>(
  (ref, orderId) async {
    final orderService = ref.watch(orderServiceProvider);
    return orderService.getOrder(orderId);
  },
);