import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pfe_app/constants/error_handling.dart';
import 'package:pfe_app/constants/global_variables.dart';
import 'package:pfe_app/constants/utils.dart';
import 'package:pfe_app/models/order.dart';
import 'package:pfe_app/models/product.dart';
import 'package:pfe_app/models/rating.dart';
import 'package:pfe_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class AdminServices {
  Future<String> sellProduct({
    required BuildContext context,
    required String name,
    required String description,
    required double price,
    required int quantity,
    required String category,
    required List<File> images,
    required List<Rating>? rating,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      //  print('0$images');
      final cloudinary = CloudinaryPublic('dm32ciz26', 'hhryfvyn');
      List<String> imageUrls = [];

      for (int i = 0; i < images.length; i++) {
        CloudinaryResponse res = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(images[i].path, folder: name),
        );
        imageUrls.add(res.secureUrl);
      }

      Product product = Product(
        name: name,
        description: description,
        quantity: quantity,
        images: imageUrls,
        category: category,
        price: price,
        manufacturer: ' ',
        rating: [],
      );

      http.Response res = await http.post(
        Uri.parse('$uri/products'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'token': 'seller_94efce7f',
        },
        body: product.toJson(),
      );
      String productId = await res.body;

      print('object$productId');

      if (res.statusCode == 202) {
        String productId = await res.body;
        print('productId$productId');
        return productId;
      }

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Product Added Successfully!');
          Navigator.pop(context);
        },
      );
      return productId;
    } catch (e) {
      showSnackBar(context, e.toString());
      return '0';
    }
  }

  Future<Product> fetchProductById(int id) async {
    final url = Uri.parse('$uri/product/$id');
    final response = await http.get(url);
    var res = await response.body;
    print(res);
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final product = Product.fromJson(jsonResponse);
      return product;
    } else {
      throw Exception('Failed to fetch product');
    }
  }

  // get all the products
  Future<List<Product>> fetchAllProducts(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];
    try {
      http.Response res =
          await http.get(Uri.parse('$uri/products/seller/161'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        // 'x-auth-token': userProvider.user.token,
      });
      print(res.body);

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            print('0$jsonDecode(res.body)');
            productList.add(
              Product.fromJson(
                jsonEncode(
                  jsonDecode(res.body)[i],
                ),
              ),
            );
            //productList[i].sqty(productList[i].quantity.toDouble());
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    print('aaa$productList');

    return productList;
  }

  void deleteProduct({
    required BuildContext context,
    required Product product,
    required VoidCallback onSuccess,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      var a = product.id;
      print('object:$a');
      http.Response res = await http.delete(
        Uri.parse('$uri/product/$a'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          //  'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'id': product.id,
        }),
      );
      int aa = res.statusCode;
      print('0object0 :$aa');

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          onSuccess();
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> updateProductInCatalog({
    required String jsonString,
    required File file,
  }) async {
    final String apiUrl = '$uri/products';
    final cloudinary = CloudinaryPublic('dm32ciz26', 'hhryfvyn');
    String qr = '';
    final jsonData = jsonDecode(jsonString);
    final String productName = jsonData['productName'];

    CloudinaryResponse res = await cloudinary.uploadFile(
      CloudinaryFile.fromFile(file.path, folder: productName),
    );
    qr = res.secureUrl;

    Map<String, dynamic> jsonMap = json.decode(jsonString);
    jsonMap['qrCode'] = qr;
    String updatedJsonString = json.encode(jsonMap);

    http.Response resp = await http.put(
      Uri.parse('$uri/products'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        // 'token': 'seller_5a109779',
      },
      body: updatedJsonString,
    );
  }
}
