// lib/core/services/cart_service.dart
/*import 'package:appwrite/appwrite.dart';
import '../constants/app_constants.dart';
import '../models/cart_model.dart';

class CartService {
  final Databases databases;

  CartService({required this.databases});

  Future<CartModel> getCart(String userId) async {
    try {
      final result = await databases.listDocuments(
        databaseId: AppConstants.databaseId,
        collectionId: AppConstants.cartsCollection,
        queries: [Query.equal('userId', userId)],
      );

      if (result.documents.isEmpty) {
        return CartModel(id: ID.unique(), userId: userId, items: [], total: 0.0);
      }

      return CartModel.fromJson(result.documents.first.data);
    } catch (e) {
      throw Exception('Failed to fetch cart: $e');
    }
  }

  Future<void> addToCart(CartItem item) async {
    try {
      final cart = await getCart(item.userId);
      cart.items.add(item);
      cart.total += item.price * item.quantity;

      await databases.updateDocument(
        databaseId: AppConstants.databaseId,
        collectionId: AppConstants.cartsCollection,
        documentId: cart.id,
        data: cart.toJson(),
      );
    } catch (e) {
      throw Exception('Failed to add item to cart: $e');
    }
  }

  Future<void> removeFromCart(String userId, String productId) async {
    try {
      final cart = await getCart(userId);
      final item = cart.items.firstWhere((item) => item.productId == productId);
      cart.items.remove(item);
      cart.total -= item.price * item.quantity;

      await databases.updateDocument(
        databaseId: AppConstants.databaseId,
        collectionId: AppConstants.cartsCollection,
        documentId: cart.id,
        data: cart.toJson(),
      );
    } catch (e) {
      throw Exception('Failed to remove item from cart: $e');
    }
  }

  Future<void> clearCart(String userId) async {
    try {
      final cart = await getCart(userId);
      cart.items.clear();
      cart.total = 0.0;

      await databases.updateDocument(
        databaseId: AppConstants.databaseId,
        collectionId: AppConstants.cartsCollection,
        documentId: cart.id,
        data: cart.toJson(),
      );
    } catch (e) {
      throw Exception('Failed to clear cart: $e');
    }
  }
}*/

// lib/services/cart_service.dart
import 'package:appwrite/appwrite.dart';
import '../constants/app_constants.dart';
import '../models/cart_model.dart';

class CartService {
  final Databases databases;

  CartService({required this.databases});

  // Fetch the current cart for the user
  Future<CartModel> getCart(String userId) async {
    try {
      final result = await databases.listDocuments(
        databaseId: AppConstants.databaseId,
        collectionId: AppConstants.cartsCollection,
        queries: [Query.equal('userId', userId)],
      );

      if (result.documents.isEmpty) {
        final newCart = CartModel(
          id: ID.unique(),
          userId: userId,
          items: [],
          total: 0.0,
        );

        await databases.createDocument(
          databaseId: AppConstants.databaseId,
          collectionId: AppConstants.cartsCollection,
          documentId: newCart.id,
          data: newCart.toJson(),
        );

        return newCart;
      }

      return CartModel.fromJson(result.documents.first.data);
    } catch (e) {
      throw Exception('Failed to fetch cart: $e');
    }
  }

  // Add a product to the cart or increase the quantity if the item already exists
  Future<void> addToCart({
    required String userId,
    required String productId,
    required double price,
    required String imageUrl,
    required String name,
  }) async {
    try {
      final cart = await getCart(userId);
      String itemString = "$productId:1:$price:$imageUrl:$name";
      
      // Check if item exists in cart
      int index = cart.items.indexWhere((item) => item.startsWith(productId));
      if (index != -1) {
        // Update the quantity of the existing item
        final parts = cart.items[index].split(':');
        final quantity = int.parse(parts[1]) + 1;
        cart.items[index] = "$productId:$quantity:$price:$imageUrl:$name";
      } else {
        // Add the new item to the cart
        cart.items.add(itemString);
      }

      // Recalculate total amount
      cart.total = cart.items.fold(0.0, (sum, item) {
        final parts = item.split(':');
        return sum + (double.parse(parts[1]) * double.parse(parts[2]));
      });

      // Update the cart in the database
      await databases.updateDocument(
        databaseId: AppConstants.databaseId,
        collectionId: AppConstants.cartsCollection,
        documentId: cart.id,
        data: cart.toJson(),
      );
    } catch (e) {
      throw Exception('Failed to add item to cart: $e');
    }
  }

  // Remove a product from the cart
  Future<void> removeFromCart(String userId, String productId) async {
    try {
      final cart = await getCart(userId);
      
      // Remove the item from the cart
      cart.items.removeWhere((item) => item.startsWith(productId));

      // Recalculate the total amount after removing the item
      cart.total = cart.items.fold(0.0, (sum, item) {
        final parts = item.split(':');
        return sum + (double.parse(parts[1]) * double.parse(parts[2]));
      });

      // Update the cart in the database
      await databases.updateDocument(
        databaseId: AppConstants.databaseId,
        collectionId: AppConstants.cartsCollection,
        documentId: cart.id,
        data: cart.toJson(),
      );
    } catch (e) {
      throw Exception('Failed to remove item from cart: $e');
    }
  }

  // Clear all items in the cart
  Future<void> clearCart(String userId) async {
    try {
      final cart = await getCart(userId);
      cart.items.clear();
      cart.total = 0.0;

      // Update the cart in the database with no items
      await databases.updateDocument(
        databaseId: AppConstants.databaseId,
        collectionId: AppConstants.cartsCollection,
        documentId: cart.id,
        data: cart.toJson(),
      );
    } catch (e) {
      throw Exception('Failed to clear cart: $e');
    }
  }

  // Change the quantity of an item (increase or decrease)
  Future<void> changeQuantity({
    required String userId,
    required String productId,
    required double price,
    required String imageUrl,
    required String name,
    required int delta,
  }) async {
    try {
      final cart = await getCart(userId);

      // Find the item in the cart
      int index = cart.items.indexWhere((item) => item.startsWith(productId));
      if (index != -1) {
        final parts = cart.items[index].split(':');
        int quantity = int.parse(parts[1]);

        // Update the quantity based on delta (positive or negative)
        quantity += delta;

        // Ensure quantity doesn't go below 1
        if (quantity > 0) {
          cart.items[index] = "$productId:$quantity:$price:$imageUrl:$name";
        } else {
          // If quantity is 0, remove the item from the cart
          cart.items.removeAt(index);
        }
      } else if (delta > 0) {
        // If item doesn't exist and delta is positive, add it to the cart
        cart.items.add("$productId:1:$price:$imageUrl:$name");
      }

      // Recalculate total
      cart.total = cart.items.fold(0.0, (sum, item) {
        final parts = item.split(':');
        return sum + (double.parse(parts[1]) * double.parse(parts[2]));
      });

      // Update cart in the database
      await databases.updateDocument(
        databaseId: AppConstants.databaseId,
        collectionId: AppConstants.cartsCollection,
        documentId: cart.id,
        data: cart.toJson(),
      );
    } catch (e) {
      throw Exception('Failed to update item quantity in cart: $e');
    }
  }
}


