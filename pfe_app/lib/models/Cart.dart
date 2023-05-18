import 'dart:convert';

import 'package:pfe_app/models/CartItem.dart';
import 'package:pfe_app/models/customer.dart';
import 'package:pfe_app/models/product.dart';

class Cart {
  final String cartId;
  final List<CartItem> cartItems;
  final double cartTotal;
  final Customer customer;

  Cart({
    required this.cartId,
    required this.cartItems,
    required this.cartTotal,
    required this.customer,
  });

  Map<String, dynamic> toMap() {
    return {
      //'id': id,

      'cartItems': cartItems.map((x) => x.toMap()).toList(),
      'cartTotal': cartTotal,
      'customer': customer,
    };
  }

  factory Cart.fromMap(Map<String, dynamic> map) {
    return Cart(
      cartId: map['cartId'] ?? '',
      cartItems: List<CartItem>.from(
          map['cartItems']?.map((x) => CartItem.fromMap(x['cartItem']))),
      cartTotal: map['cartTotal'] ?? '',
      customer: map['customer'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Cart.fromJson(String source) => Cart.fromMap(json.decode(source));
}
