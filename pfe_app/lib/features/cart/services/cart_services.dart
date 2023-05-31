import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pfe_app/constants/error_handling.dart';
import 'package:pfe_app/constants/global_variables.dart';
import 'package:pfe_app/constants/utils.dart';
import 'package:pfe_app/models/Cart.dart';
import 'package:pfe_app/models/CartItem.dart';
import 'package:pfe_app/models/product.dart';
import 'package:pfe_app/models/user.dart';
import 'package:pfe_app/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CartServices {
  void removeFromCart({
    required BuildContext context,
    required Product product,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.delete(
        Uri.parse('$uri/api/remove-from-cart/${product.id}'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          /*    User user =
              userProvider.user.copyWith(cart: jsonDecode(res.body)['cart']);
          userProvider.setUserFromModel(user);*/
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<List<Product>> fetchCart(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];
    try {
      http.Response res = await http.get(Uri.parse('$uri/cart'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'token': userProvider.user.token,
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

  Future<List<CartItem>> getCartProduct(BuildContext context) async {
    final url = Uri.parse('$uri/cart0');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('x-auth-token')!;
    final response = await http.get(
      url,
      headers: {'token': token},
    );
    var s = response.body;
    print('Status$s');
    if (response.statusCode == 202) {
      final jsonData = jsonDecode(response.body);
      List<CartItem> productList = [];
      for (int i = 0; i < jsonData.length; i++) {
        productList.add(CartItem.fromJson(jsonEncode(jsonData[i])));
      }
      return productList;
    } else {
      throw Exception('Failed to fetch cart product');
    }
  }

  Future<double> fetchCartTotal() async {
    final apiUrl = '$uri/cartTotal'; // Replace with your actual API endpoint
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('x-auth-token')!;
      final response =
          await http.get(Uri.parse(apiUrl), headers: {'token': token});
      print(response.statusCode);
      if (response.statusCode == 202) {
        final total = double.parse(response.body);
        return total;
      } else {
        throw Exception('Failed to fetch cart total');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }
}
