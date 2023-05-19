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
  //final List<Rating>? rating;

  Product({
    required this.name,
    required this.description,
    required this.quantity,
    required this.images,
    required this.category,
    required this.price,
    this.id,
    required this.manufacturer,
    //  this.rating,
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
      //'rating': rating,
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

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source));
}
