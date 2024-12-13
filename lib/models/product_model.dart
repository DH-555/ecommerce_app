// lib/models/product_model.dart
/*class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final int stock;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.stock,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['\$id'] ?? json['id'],
      name: json['name'],
      description: json['description'],
      price: double.parse(json['price'].toString()),
      imageUrl: json['imageUrl'],
      stock: json['stock'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'stock': stock,
    };
  }
}*/


// lib/models/product_model.dart
class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final int stock;
  final String? additionalText; // Optional additional text for product features
  final double? discountPercentage; // Optional discount percentage
  final double? ratings; // Average rating
  final List<int> userRatings; // List of user ratings (1-5 scale)
  final List<String> categories; // Categories for the product

  // Constructor for the model
  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.stock,
    this.additionalText,
    this.discountPercentage,
    this.ratings,
    required this.userRatings, // List of individual ratings
    required this.categories,
  });

  // Factory constructor to create the model from JSON
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['\$id'] ?? json['id'],
      name: json['name'],
      description: json['description'],
      price: double.parse(json['price'].toString()),
      imageUrl: json['imageUrl'],
      stock: json['stock'],
      additionalText: json['additionalText'],
      discountPercentage: json['discountPercentage'] != null
          ? double.parse(json['discountPercentage'].toString())
          : null,
      ratings: json['ratings'] != null
          ? double.parse(json['ratings'].toString())
          : null,
      userRatings: List<int>.from(json['userRatings'] ?? []),
      categories: List<String>.from(json['categories'] ?? []),
    );
  }

  // Method to convert the model back to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'stock': stock,
      'additionalText': additionalText,
      'discountPercentage': discountPercentage,
      'ratings': ratings,
      'userRatings': userRatings,
      'categories': categories,
    };
  }


  double get discountedPrice {
    if (discountPercentage != null && discountPercentage! > 0) {
      return price * (1 - discountPercentage! / 100);
    }
    return price;
  }

  // Calculate the average rating
  double get averageRating {
    if (userRatings.isEmpty) {
      return 0.0;
    }
    return userRatings.reduce((a, b) => a + b) / userRatings.length.toDouble();
  }

  // Method to add a rating
  void addRating(int rating) {
    if (rating >= 1 && rating <= 5) {
      userRatings.add(rating);
    }
  }
}