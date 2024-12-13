// lib/services/order_service.dart
import 'package:appwrite/appwrite.dart';
import '../constants/app_constants.dart';
import '../models/order_model.dart';
import '../models/cart_model.dart';

class OrderService {
  final Databases databases;

  OrderService({required this.databases});

  Future<OrderModel> createOrder({
    required String userId,
    required CartModel cart,
    required String address,
  }) async {
    try {
      // Directly use the cart items as strings in the order
      final order = OrderModel(
        id: ID.unique(),
        userId: userId,
        items: cart.items, // Directly pass the items as List<String>
        total: cart.total,
        address: address,
        orderDate: DateTime.now(),
        status: OrderStatus.pending,
        paymentId: null, // Optional field; can be added later
      );

      await databases.createDocument(
        databaseId: AppConstants.databaseId,
        collectionId: AppConstants.ordersCollection,
        documentId: order.id,
        data: order.toJson(),
      );

      return order;
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }

  Future<List<OrderModel>> getUserOrders(String userId) async {
    try {
      final result = await databases.listDocuments(
        databaseId: AppConstants.databaseId,
        collectionId: AppConstants.ordersCollection,
        queries: [
          Query.equal('userId', userId),
          Query.orderDesc('orderDate'),
        ],
      );

      return result.documents
          .map((doc) => OrderModel.fromJson(doc.data))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch orders: $e');
    }
  }

  Future<OrderModel> getOrder(String orderId) async {
    try {
      final result = await databases.getDocument(
        databaseId: AppConstants.databaseId,
        collectionId: AppConstants.ordersCollection,
        documentId: orderId,
      );

      return OrderModel.fromJson(result.data);
    } catch (e) {
      throw Exception('Failed to fetch order: $e');
    }
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    try {
      await databases.updateDocument(
        databaseId: AppConstants.databaseId,
        collectionId: AppConstants.ordersCollection,
        documentId: orderId,
        data: {'status': status.toString()},
      );
    } catch (e) {
      throw Exception('Failed to update order status: $e');
    }
  }
}
