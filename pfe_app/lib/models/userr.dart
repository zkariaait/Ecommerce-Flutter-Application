import 'dart:convert';

class Userr {
  final String? id;
  final String name;
  final String lastName;
  final String mobileNo;
  final String emailId;
  final String password;
  final String address;
  final String type;
  final String token;
  final List<dynamic> cart;

  Userr({
    required this.id,
    required this.name,
    required this.lastName,
    required this.mobileNo,
    required this.emailId,
    required this.password,
    required this.address,
    required this.type,
    required this.token,
    required this.cart,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': name,
      'lastName': lastName,
      'mobileNo': mobileNo,
      'emailId': emailId,
      'password': password,
    };
  }

  factory Userr.fromMap(Map<String, dynamic> map) {
    return Userr(
      id: map['customerId'] ?? '',
      name: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      mobileNo: map['mobileNo'] ?? '',
      emailId: map['emailId'] ?? '',
      password: map['password'] ?? '',
      address: map['address'] ?? '',
      type: map['type'] ?? '',
      token: map['token'] ?? '',
      cart: List<Map<String, dynamic>>.from(
        map['cart']?.map(
          (x) => Map<String, dynamic>.from(x),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Userr.fromJson(String source) => Userr.fromMap(json.decode(source));

  Userr copyWith({
    String? id,
    String? name,
    String? lastName,
    String? mobileNo,
    String? emailId,
    String? password,
    String? address,
    String? type,
    String? token,
    List<dynamic>? cart,
  }) {
    return Userr(
      id: id ?? this.id,
      name: name ?? this.name,
      lastName: lastName ?? this.lastName,
      mobileNo: mobileNo ?? this.mobileNo,
      emailId: emailId ?? this.emailId,
      password: password ?? this.password,
      address: address ?? this.address,
      type: type ?? this.type,
      token: token ?? this.token,
      cart: cart ?? this.cart,
    );
  }
}
