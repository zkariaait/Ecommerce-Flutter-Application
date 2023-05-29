import 'dart:convert';

class User {
  final String? id;
  final String name;
  final String lastName;
  final String mobileNo;
  final String emailId;
  final String password;
  final String address;
  final String type;
  final String token;

  User({
    required this.id,
    required this.name,
    required this.lastName,
    required this.mobileNo,
    required this.emailId,
    required this.password,
    required this.address,
    required this.type,
    required this.token,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': name,
      'lastName': lastName,
      'mobileNo': mobileNo,
      'emailId': emailId,
      'password': password,
      /*    'address': address,
      'type': type,
      'token': token,*/
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['customerId'] ?? '',
      name: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      mobileNo: map['mobileNo'] ?? '',
      emailId: map['emailId'] ?? '',
      password: map['password'] ?? '',
      address: map['address'] ?? '',
      type: map['type'] ?? '',
      token: map['token'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  User copyWith({
    String? id,
    String? name,
    String? lastName,
    String? mobileNo,
    String? emailId,
    String? password,
    String? address,
    String? type,
    String? token,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      lastName: lastName ?? this.lastName,
      mobileNo: mobileNo ?? this.mobileNo,
      emailId: emailId ?? this.emailId,
      password: password ?? this.password,
      address: address ?? this.address,
      type: type ?? this.type,
      token: token ?? this.token,
    );
  }
}
