import 'dart:convert';

class Product {
  final String name;
  final String description;
  final int quantity;
  final List<String> images;
  final String category;
  final double price;
  final String? id;
  final String manufacturer;

  Product({
    required this.name,
    required this.description,
    required this.quantity,
    required this.images,
    required this.category,
    required this.price,
    this.id,
    required this.manufacturer,
  });

  Map<String, dynamic> toMap() {
    return {
      'productName': name,
      'description': description,
      'quantity': quantity,
      'images': images,
      'category': category,
      'price': price,
      'manufacturer': manufacturer,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['productId'] != null ? map['productId'].toString() : null,
      name: map['productName'] ?? '',
      description: map['description'] ?? '',
      quantity: map['quantity'] ?? 0,
      images: List<String>.from(map['images']),
      category: map['category'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      manufacturer: map['manufacturer'],
    );
  }

  static Product fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      quantity: json['quantity'],
      images: List<String>.from(json['images']),
      category: json['category'],
      price: json['price'].toDouble(),
      manufacturer: json['manufacturer'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'quantity': quantity,
      'images': images,
      'category': category,
      'price': price,
      'manufacturer': manufacturer,
    };
  }
}
