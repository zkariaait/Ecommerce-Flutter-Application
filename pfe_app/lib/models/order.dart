import 'dart:convert';
import 'dart:io';

import 'package:pfe_app/models/CartItem.dart';
import 'package:pfe_app/models/address.dart';
import 'package:pfe_app/models/customer.dart';
import 'package:pfe_app/models/product.dart';

class Order {
  final String orderId;
  final Customer customer;
  //final String address;
  final HttpDate date;
  final String orderStatus;
  final double total;
  final List<CartItem> ordercartItems;
  final Address address;

  Order({
    required this.orderId,
    required this.ordercartItems,
    //required this.quantity,
    required this.date,
    required this.orderStatus,
    required this.total,
    required this.address,
    required this.customer,
  });

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'ordercartItems': ordercartItems.map((x) => x.toMap()).toList(),
      'date': date,
      'orderStatus': orderStatus,
      'total': total,
      'address': address,
      'customer': customer,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      orderId: map['orderId'] ?? '',
      ordercartItems: List<CartItem>.from(
          map['ordercartItems']?.map((x) => Product.fromMap(x['CartItem']))),
      address: map['address'] ?? '',
      date: map['date'] ?? '',
      orderStatus: map['orderStatus'] ?? '',
      total: map['total']?.toInt() ?? 0.0,
      customer: map['customer'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) => Order.fromMap(json.decode(source));
}
