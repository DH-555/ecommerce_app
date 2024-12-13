import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';  // Import the cached_network_image package
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _refreshCart();
  }

  Future<void> _refreshCart() async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    ref.refresh(cartProvider); // Refresh the cart provider
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF2874F0)))
          : authState.when(
              data: (user) {
                if (user == null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.account_circle_outlined, size: 70, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          'Please login to view your cart',
                          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  );
                }

                return cartState.when(
                  data: (cart) {
                    if (cart.items.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.shopping_cart_outlined, size: 70, color: Colors.grey),
                            const SizedBox(height: 16),
                            Text(
                              'Your cart is empty',
                              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                            ),
                            const SizedBox(height: 16),
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text(
                                'Continue Shopping',
                                style: TextStyle(
                                  color: Color(0xFF2874F0),
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: cart.items.length,
                            itemBuilder: (context, index) {
                              final cartItem = cart.items[index];

                              // Split by the first 4 colons, treat the last part as the name
                              final parts = cartItem.split(':');
                              
                              // Debug print to see the cart item data
                              debugPrint("Cart item at index $index: $cartItem");

                              // Ensure there are at least 5 parts (productId, quantity, price, imageUrl, name)
                              if (parts.length < 5) {
                                debugPrint("Invalid cart item data: $cartItem");
                                return Container(); // Skip this item if it's invalid
                              }

                              final productId = parts[0];     // Product ID
                              final quantity = int.tryParse(parts[1]) ?? 0;   // Quantity (handle null)
                              final price = double.tryParse(parts[2]) ?? 0.0;  // Price (handle null)
                              
                              // Image URL: Everything between 3rd colon and last colon
                              final imageUrl = parts.sublist(3, parts.length - 1).join(':') ?? '';
                              
                              // The last part is the name
                              final name = parts.last ?? '';

                              // Debug prints for individual values
                              debugPrint("Product ID: $productId");
                              debugPrint("Image URL: $imageUrl");
                              debugPrint("Name: $name");
                              debugPrint("Quantity: $quantity");
                              debugPrint("Price: $price");

                              // Handle missing values by providing fallback values if necessary
                              if (imageUrl.isEmpty || name.isEmpty) {
                                return Container(); // Skip rendering this item if data is incomplete
                              }

                              return Dismissible(
                                key: Key(productId),
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  color: Colors.red[400],
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 16),
                                  child: const Icon(Icons.delete, color: Colors.white),
                                ),
                                onDismissed: (direction) {
                                  ref.read(cartServiceProvider).removeFromCart(
                                    user.id,
                                    productId,
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 1),
                                  color: Colors.white,
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Use CachedNetworkImage with a placeholder
                                      Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey[300]!),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl: imageUrl,
                                          placeholder: (context, url) => const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                          errorWidget: (context, url, error) => const Icon(Icons.error),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              name,
                                              style: const TextStyle(fontSize: 16),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              '₹${(price * quantity).toStringAsFixed(2)}',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              children: [
                                                IconButton(
                                                  icon: const Icon(Icons.remove, size: 20),
                                                  onPressed: () {
                                                    if (quantity > 1) {
                                                      ref.read(cartServiceProvider).changeQuantity(
                                                        userId: user.id,
                                                        productId: productId,
                                                        price: price,
                                                        imageUrl: imageUrl,
                                                        name: name,
                                                        delta: -1, // Decrease quantity
                                                      );
                                                    } else {
                                                      // Remove the item from the cart if quantity is 1
                                                      ref.read(cartServiceProvider).removeFromCart(
                                                        user.id,
                                                        productId,
                                                      );
                                                    }

                                                    // Delay for 1 second before refreshing the UI
                                                    Future.delayed(const Duration(seconds: 1), () {
                                                      _refreshCart();
                                                    });
                                                  },
                                                ),
                                                Text('$quantity', style: const TextStyle(fontSize: 16)),
                                                IconButton(
                                                  icon: const Icon(Icons.add, size: 20),
                                                  onPressed: () {
                                                    ref.read(cartServiceProvider).changeQuantity(
                                                      userId: user.id,
                                                      productId: productId,
                                                      price: price,
                                                      imageUrl: imageUrl,
                                                      name: name,
                                                      delta: 1, // Increase quantity
                                                    );

                                                    // Delay for 1 second before refreshing the UI
                                                    Future.delayed(const Duration(seconds: 1), () {
                                                      _refreshCart();
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/checkout');
                            },
                            child: const Text('Proceed to Checkout'),
                          ),
                        ),
                      ],
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(child: Text('Error: $error')),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
    );
  }
}








/*import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: authState.when(
        data: (user) {
          if (user == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.account_circle_outlined, size: 70, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'Please login to view your cart',
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                ],
              ),
            );
          }

          return cartState.when(
            data: (cart) {
              if (cart.items.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.shopping_cart_outlined, size: 70, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(
                        'Your cart is empty',
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Continue Shopping',
                          style: TextStyle(
                            color: Color(0xFF2874F0),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: cart.items.length,
                      itemBuilder: (context, index) {
                        final parts = cart.items[index].split(':');
                        final productId = parts[0];
                        final quantity = int.parse(parts[1]);
                        final price = double.parse(parts[2]);

                        return Dismissible(
                          key: Key(productId),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            color: Colors.red[400],
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 16),
                            child: const Icon(Icons.delete, color: Colors.white),
                          ),
                          onDismissed: (direction) {
                            ref.read(cartServiceProvider).removeFromCart(
                              user.id,
                              productId,
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 1),
                            color: Colors.white,
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey[300]!),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Icon(Icons.shopping_bag_outlined, color: Colors.grey),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Product $productId',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        '₹${(price * quantity).toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.remove, size: 20),
                                            onPressed: () {
                                              if (quantity > 1) {
                                                ref.read(cartServiceProvider).changeQuantity(
                                                  userId: user.id,
                                                  productId: productId,
                                                  price: price,
                                                  delta: -1, // Decrease quantity
                                                );
                                              }
                                            },
                                          ),
                                          Text(
                                            '$quantity',
                                            style: const TextStyle(fontSize: 16),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.add, size: 20),
                                            onPressed: () {
                                              ref.read(cartServiceProvider).changeQuantity(
                                                userId: user.id,
                                                productId: productId,
                                                price: price,
                                                delta: 1, // Increase quantity
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total Amount',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              '₹${cart.total.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/checkout');
                            },
                            child: const Text(
                              'PLACE ORDER',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(color: Color(0xFF2874F0)),
            ),
            error: (error, stack) => Center(child: Text('Error: $error')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFF2874F0))),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}*/

