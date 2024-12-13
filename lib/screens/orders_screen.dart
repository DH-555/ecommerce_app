/*import 'package:ecommerce_app/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/order_provider.dart';
import '../providers/auth_provider.dart';

class OrdersScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        elevation: 4,
      ),
      body: authState.when(
        data: (user) {
          if (user == null) {
            return const Center(
              child: Text('Please login to view orders', style: TextStyle(fontSize: 18)),
            );
          }

          final ordersState = ref.watch(userOrdersProvider(user.id));

          return ordersState.when(
            data: (orders) {
              if (orders.isEmpty) {
                return const Center(
                  child: Text('No orders found', style: TextStyle(fontSize: 18)),
                );
              }

              return ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/order-details',
                            arguments: order.id,
                          );
                        },
                        contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                        title: Text(
                          'Order #${order.id.substring(0, 8)}',
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total: \$${order.total.toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: Colors.green,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            _StatusChip(order.status),
                          ],
                        ),
                        trailing: Text(
                          '${order.orderDate.toLocal()}'.split(' ')[0],
                          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) {
              return Center(
                child: Text(
                  'Error: $error',
                  style: TextStyle(fontSize: 16, color: Colors.red),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) {
          return Center(
            child: Text(
              'Error: $error',
              style: TextStyle(fontSize: 16, color: Colors.red),
            ),
          );
        },
      ),
    );
  }

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
      label: Text(statusText),
      backgroundColor: statusColor,
      labelStyle: const TextStyle(color: Colors.white),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    );
  }
}*/


import 'package:ecommerce_app/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/order_provider.dart';
import '../providers/auth_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class OrdersScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Sliver AppBar
          SliverAppBar(
            floating: true,
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              'My Orders',
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            iconTheme: IconThemeData(color: Colors.black87),
          ),
          
          // Orders content
          SliverFillRemaining(
            child: authState.when(
              data: (user) {
                if (user == null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.account_circle_outlined, size: 70, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'Please login to view your orders',
                          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  );
                }

                final ordersState = ref.watch(userOrdersProvider(user.id));

                return ordersState.when(
                  data: (orders) {
                    if (orders.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.shopping_bag_outlined, size: 70, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'No orders found',
                              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final order = orders[index];
                        return Container(
                          margin: EdgeInsets.only(bottom: 1),
                          color: Colors.white,
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/order-details',
                                arguments: order.id,
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Order #${order.id.substring(0, 8)}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '${order.orderDate.toLocal()}'.split(' ')[0],
                                        style: TextStyle(color: Colors.grey[600]),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    '₹${order.total.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF388E3C),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  _StatusChip(order.status),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  loading: () => Center(child: CircularProgressIndicator(color: Color(0xFF2874F0))),
                  error: (error, stackTrace) {
                    return Center(
                      child: Text(
                        'Error: $error',
                        style: TextStyle(fontSize: 16, color: Colors.red),
                      ),
                    );
                  },
                );
              },
              loading: () => Center(child: CircularProgressIndicator(color: Color(0xFF2874F0))),
              error: (error, stackTrace) {
                return Center(
                  child: Text(
                    'Error: $error',
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  ),
                );
              },
            ),
          ),
        ],
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


