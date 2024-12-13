// lib/models/cart_model.dart
/*class CartModel {
  final String id;
  final String userId;
  final List<CartItem> items;
  double total;

  CartModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.total,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['\$id'] ?? json['id'],
      userId: json['userId'],
      items: (json['items'] as List)
          .map((item) => CartItem.fromJson(item))
          .toList(),
      total: double.parse(json['total'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'items': items.map((item) => item.toJson()).toList(),
      'total': total,
    };
  }
}

class CartItem {
  final String productId;
  int quantity;
  double price;

  CartItem({
    required this.productId,
    required this.quantity,
    required this.price,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productId: json['productId'],
      quantity: json['quantity'],
      price: double.parse(json['price'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
      'price': price,
    };
  }
}*/


// lib/models/cart_model.dart
class CartModel {
  final String id;
  final String userId;
  final List<String> items; // Each item as "productId:quantity:price"
  double total;

  CartModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.total,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['\$id'] ?? json['id'],
      userId: json['userId'],
      items: List<String>.from(json['items']),
      total: double.parse(json['total'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'items': items,
      'total': total,
    };
  }
}
