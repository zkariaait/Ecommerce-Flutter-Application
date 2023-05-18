import 'dart:convert';
import 'dart:io';

import 'package:pfe_app/models/CartItem.dart';
import 'package:pfe_app/models/customer.dart';
import 'package:pfe_app/models/product.dart';

class Address {
  final String addressId;
  final String buildingName;
  final String streetNo;
  final String city;
  final String pincode;
  final Customer customer;

  Address({
    required this.addressId,
    required this.buildingName,
    //required this.quantity,
    required this.streetNo,
    required this.city,
    required this.pincode,
    required this.customer,
  });

  Map<String, dynamic> toMap() {
    return {
      'addressId': addressId,
      'buildingName': buildingName,
      'streetNo': streetNo,
      'city': city,
      'pincode': pincode,
      'customer': customer,
    };
  }

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      addressId: map['addressId'] ?? '',
      buildingName: map['buildingName'] ?? '',
      streetNo: map['streetNo'] ?? '',
      city: map['city'] ?? '',
      pincode: map['pincode'] ?? '',
      customer: map['customer'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Address.fromJson(String source) =>
      Address.fromMap(json.decode(source));
}
