import 'dart:convert';

import 'package:pfe_app/models/product.dart';

class CartItem {
  final String id;
  final Product cartProduct;
  final int cartItemQuantity;

  CartItem({
    required this.id,
    required this.cartProduct,
    required this.cartItemQuantity,
  });

  Map<String, dynamic> toMap() {
    return {
      //'id': id,
      'cartProduct': cartProduct,
      'cartItemQuantity': cartItemQuantity,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['cartItemId'] ?? '',
      cartProduct: map['cartProduct'] ?? '',
      cartItemQuantity: map['cartItemQuantity'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CartItem.fromJson(String source) =>
      CartItem.fromMap(json.decode(source));
}
