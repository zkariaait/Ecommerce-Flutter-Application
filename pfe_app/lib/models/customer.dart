import 'dart:convert';

import 'package:pfe_app/models/order.dart';
import 'package:pfe_app/models/user.dart';
import 'package:pfe_app/models/Cart.dart';

class Customer extends User {
  final List<Order> orders;
  final Cart customerCart;

  Customer({
    required super.name,
    required super.lastName,
    required super.mobileNo,
    required super.emailId,
    required super.password,
    required super.address,
    required super.type,
    required super.token,
    required this.orders,
    required this.customerCart,
  });

  Map<String, dynamic> toMap() {
    return {
      //  'id': id,
      'firstName': name,
      'lastName': lastName,
      'mobileNo': mobileNo,
      'emailId': emailId,
      'password': password,
      'customerCart': customerCart,
      'orders': orders.map((x) => x.toMap()).toList(),

      /*    'address': address,
      'type': type,
      'token': token,*/
    };
  }

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
        //id: map['customerId'] ?? '',
        name: map['firstName'] ?? '',
        lastName: map['lastName'] ?? '',
        mobileNo: map['mobileNo'] ?? '',
        emailId: map['emailId'] ?? '',
        password: map['password'] ?? '',
        address: map['address'] ?? '',
        type: map['type'] ?? '',
        token: map['token'] ?? '',
        customerCart: map['customerCart'] ?? '',
        orders: List<Order>.from(
            map['orders']?.map((x) => Order.fromMap(x['order']))));
  }

  String toJson() => json.encode(toMap());

  factory Customer.fromJson(String source) =>
      Customer.fromMap(json.decode(source));
  //body of child class
}
