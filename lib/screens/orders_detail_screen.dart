/*import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/order_provider.dart';
import '../models/order_model.dart';

class OrderDetailsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Fetch order ID from the route arguments
    final orderId = ModalRoute.of(context)!.settings.arguments as String;
    final orderState = ref.watch(orderProvider(orderId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        elevation: 4,
      ),
      body: orderState.when(
        data: (order) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order ID
                Text('Order ID: ${order.id}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),

                // Total Price
                Text('Total: \$${order.total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),

                // Order Status Chip
                _StatusChip(order.status),
                const SizedBox(height: 8),

                // Delivery Address
                Text('Delivery Address:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(order.address, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                const SizedBox(height: 8),

                // Order Date
                Text('Order Date: ${order.orderDate.toLocal()}'.split(' ')[0], style: const TextStyle(fontSize: 14, color: Colors.grey)),
                const SizedBox(height: 16),

                // Items Header
                const Text('Items:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),

                // List of items in the order
                Expanded(
                  child: ListView.builder(
                    itemCount: order.items.length,
                    itemBuilder: (context, index) {
                      final itemString = order.items[index]; // Item is a string: "productId:quantity:price"
                      
                      // Split the string into its components: productId, quantity, price
                      final itemParts = itemString.split(':');
                      final productId = itemParts[0];
                      final quantity = int.parse(itemParts[1]);
                      final price = double.parse(itemParts[2]);
                      
                      // Assuming you have a way to get the product name and image based on productId
                      final productName = 'Product Name for $productId'; // Mocked name
                      final productImage = 'https://example.com/images/$productId.jpg'; // Mocked image URL

                      // Calculate total price for this item
                      final totalPrice = price * quantity;

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              productImage,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            productName,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('Quantity: $quantity', style: const TextStyle(fontSize: 14, color: Colors.grey)),
                          trailing: Text('\$${totalPrice.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) {
          return Center(child: Text('Error: $error', style: TextStyle(color: Colors.red)));
        },
      ),
    );
  }

  // Custom widget for displaying status with color coding
  Widget _StatusChip(OrderStatus status) {
    Color statusColor;
    String statusText;

    switch (status) {
      case OrderStatus.pending:
        statusColor = Colors.orange;
        statusText = 'Pending';
        break;
      case OrderStatus.delivered:
        statusColor = Colors.green;
        statusText = 'Completed';
        break;
      case OrderStatus.cancelled:
        statusColor = Colors.red;
        statusText = 'Cancelled';
        break;
      case OrderStatus.confirmed:
        statusColor = Colors.teal;
        statusText = 'Confirmed';
        break;
      default:
        statusColor = Colors.grey;
        statusText = 'Unknown';
        break;
    }

    return Chip(
      label: Text(statusText, style: const TextStyle(color: Colors.white)),
      backgroundColor: statusColor,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    );
  }
}*/



import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/order_provider.dart';
import '../models/order_model.dart';

class OrderDetailsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderId = ModalRoute.of(context)!.settings.arguments as String;
    final orderState = ref.watch(orderProvider(orderId));

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.black87),
      ),
      body: orderState.when(
        data: (order) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Order #${order.id.substring(0, 8)}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text('₹${order.total.toStringAsFixed(2)}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF388E3C))),
                      SizedBox(height: 8),
                      _StatusChip(order.status),
                      SizedBox(height: 16),
                      Text('Delivery Address:', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                      SizedBox(height: 4),
                      Text(order.address, style: TextStyle(fontSize: 16)),
                      SizedBox(height: 8),
                      Text('Order Date: ${order.orderDate.toLocal()}'.split(' ')[0], style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.all(16),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Items', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 16),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: order.items.length,
                        itemBuilder: (context, index) {
                          final itemString = order.items[index];
                          final itemParts = itemString.split(':');
                          final productId = itemParts[0];
                          final quantity = int.parse(itemParts[1]);
                          final price = double.parse(itemParts[2]);
                          final productName = 'Product Name for $productId'; // Mocked name
                          final totalPrice = price * quantity;

                          return Container(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey[300]!),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Icon(Icons.shopping_bag_outlined, color: Colors.grey),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(productName, style: TextStyle(fontSize: 16)),
                                      SizedBox(height: 4),
                                      Text('Quantity: $quantity', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                                      SizedBox(height: 4),
                                      Text('₹${totalPrice.toStringAsFixed(2)}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => Center(child: CircularProgressIndicator(color: Color(0xFF2874F0))),
        error: (error, stackTrace) {
          return Center(child: Text('Error: $error', style: TextStyle(color: Colors.red)));
        },
      ),
    );
  }

  Widget _StatusChip(OrderStatus status) {
    Color statusColor;
    String statusText;

    switch (status) {
      case OrderStatus.pending:
        statusColor = Color(0xFFFFA000);
        statusText = 'Pending';
        break;
      case OrderStatus.delivered:
        statusColor = Color(0xFF388E3C);
        statusText = 'Delivered';
        break;
      case OrderStatus.cancelled:
        statusColor = Color(0xFFD32F2F);
        statusText = 'Cancelled';
        break;
      case OrderStatus.confirmed:
        statusColor = Color(0xFF1976D2);
        statusText = 'Confirmed';
        break;
      default:
        statusColor = Colors.grey;
        statusText = 'Unknown';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          color: statusColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
