import 'dart:convert';
import 'package:pfe_app/models/product.dart';

class CartItem {
  final int id;
  final Product cartProduct;
  final int cartItemQuantity;

  CartItem({
    required this.id,
    required this.cartProduct,
    required this.cartItemQuantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'cartItemId': id,
      'cartProduct': cartProduct.toMap(),
      'cartItemQuantity': cartItemQuantity,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['cartItemId'] ?? 0,
      cartProduct: Product.fromMap(map['cartProduct']),
      cartItemQuantity: map['cartItemQuantity'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory CartItem.fromJson(String source) =>
      CartItem.fromMap(json.decode(source));
}
