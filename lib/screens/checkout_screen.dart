// lib/screens/checkout_screen.dart
/*import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart'; // Import order_provider
import '../providers/auth_provider.dart'; // Import auth_provider

class CheckoutScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);
    final authState = ref.watch(authStateProvider);  // Watch auth state

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: cartState.when(
        data: (cart) {
          return authState.when(
            data: (user) {
              if (user == null) {
                return Center(child: Text('User not logged in'));
              }

              // User is logged in, display checkout form
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total: \$${cart.total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 24)),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        // Display a dialog to get the shipping address
                        String? address = await _showAddressDialog(context);
                        if (address != null && address.isNotEmpty) {
                          // Place the order
                          try {
                            final userId = user.id; // Get the current user ID
                            final order = await ref.read(orderServiceProvider).createOrder(
                              userId: userId,
                              cart: cart,
                              address: address,
                            );

                            // Clear cart after successful order
                            ref.read(cartServiceProvider).clearCart(userId);

                            // Show success message and navigate back
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Order placed successfully')),
                            );
                            Navigator.pop(context); // Go back to previous screen
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: $e')),
                            );
                          }
                        }
                      },
                      child: const Text('Place Order'),
                    ),
                  ],
                ),
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

  // Show a dialog to get the shipping address
  Future<String?> _showAddressDialog(BuildContext context) {
    TextEditingController controller = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter Shipping Address'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Enter your address'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), 
              child: const Text('Cancel')
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, controller.text), 
              child: const Text('Place Order')
            ),
          ],
        );
      },
    );
  }
}*/


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';
import '../providers/auth_provider.dart';

class CheckoutScreen extends ConsumerWidget {
  final TextEditingController _streetAddressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _countryController = TextEditingController(text: 'India');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.black87),
      ),
      body: cartState.when(
        data: (cart) {
          return authState.when(
            data: (user) {
              if (user == null) {
                return Center(child: Text('Please log in to continue'));
              }

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Order Summary
                    Container(
                      padding: EdgeInsets.all(16),
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Order Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Total Items:', style: TextStyle(fontSize: 16)),
                              Text('${cart.items.length}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Total Amount:', style: TextStyle(fontSize: 16)),
                              Text('₹${cart.total.toStringAsFixed(2)}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green[700])),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),

                    // Shipping Address
                    Container(
                      padding: EdgeInsets.all(16),
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Shipping Address', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 16),

                          // Address Fields
                          _buildAddressField('Street Address', _streetAddressController),
                          _buildAddressField('City', _cityController),
                          _buildAddressField('State', _stateController),
                          _buildPincodeField(),
                          _buildAddressField('Country', _countryController, enabled: false),  // Country is prefilled and not editable
                        ],
                      ),
                    ),
                    SizedBox(height: 8),

                    // Payment Method
                    Container(
                      padding: EdgeInsets.all(16),
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Payment Method', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 16),
                          Text('Cash on Delivery', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
            loading: () => Center(child: CircularProgressIndicator(color: Colors.black)),
            error: (error, stack) => Center(child: Text('Error: $error')),
          );
        },
        loading: () => Center(child: CircularProgressIndicator(color: Colors.black)),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, -3),
            ),
          ],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            padding: EdgeInsets.symmetric(vertical: 16),
          ),
          onPressed: () async {
            if (_validateFields(context)) {
              try {
                final userId = authState.value!.id;
                final cart = cartState.value!;
                final address = await _getFullAddress();

                final order = await ref.read(orderServiceProvider).createOrder(
                  userId: userId,
                  cart: cart,
                  address: address,
                );

                ref.read(cartServiceProvider).clearCart(userId);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Order placed successfully')),
                );
                Navigator.pop(context);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              }
            }
          },
          child: Text(
            'PLACE ORDER',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  // Helper function to build address fields
  Widget _buildAddressField(String label, TextEditingController controller, {bool enabled = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        ),
        enabled: enabled,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$label is required';
          }
          return null;
        },
      ),
    );
  }

  // Helper function to build pincode field with validation
  Widget _buildPincodeField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: _pincodeController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: 'Pincode',
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Pincode is required';
          }
          if (value.length != 6 || int.tryParse(value) == null) {
            return 'Pincode must be 6 digits';
          }
          return null;
        },
      ),
    );
  }

  // Validate the fields
  bool _validateFields(BuildContext context) {
    if (_streetAddressController.text.isEmpty ||
        _cityController.text.isEmpty ||
        _stateController.text.isEmpty ||
        _pincodeController.text.isEmpty ||
        _pincodeController.text.length != 6 ||
        int.tryParse(_pincodeController.text) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields correctly')),
      );
      return false;
    }
    return true;
  }

  // Helper function to combine all fields into a full address string
  Future<String> _getFullAddress() async {
    return '${_streetAddressController.text}, ${_cityController.text}, ${_stateController.text}, ${_pincodeController.text}, ${_countryController.text}';
  }
}


