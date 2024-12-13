// lib/models/order_model.dart

enum OrderStatus {
  pending,
  confirmed,
  shipped,
  delivered,
  cancelled
}

class OrderModel {
  final String id;
  final String userId;
  final List<String> items; // Simplified to a list of strings (productId:quantity:price)
  final double total;
  final String address;
  final DateTime orderDate;
  final OrderStatus status;
  final String? paymentId;

  OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.total,
    required this.address,
    required this.orderDate,
    required this.status,
    this.paymentId,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['\$id'] ?? json['id'],
      userId: json['userId'],
      items: List<String>.from(json['items'] ?? []), // Directly map items as List<String>
      total: double.parse(json['total'].toString()),
      address: json['address'],
      orderDate: DateTime.parse(json['orderDate']),
      status: OrderStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
      ),
      paymentId: json['paymentId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'items': items, // Simply store items as a list of strings
      'total': total,
      'address': address,
      'orderDate': orderDate.toIso8601String(),
      'status': status.toString(),
      'paymentId': paymentId,
    };
  }
}
