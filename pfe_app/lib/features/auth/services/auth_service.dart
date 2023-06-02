import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:pfe_app/providers/user_provider.dart';
import 'package:pfe_app/constants/error_handling.dart';
import 'package:pfe_app/constants/global_variables.dart';
import 'package:pfe_app/constants/utils.dart';
import 'package:pfe_app/models/user.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/widgets/bottom_bar.dart';

class AuthService {
  // sign up user
  void signUpUser({
    required BuildContext context,
    required String email,
    required String password,
    required String name,
    required String lastName,
    required String mobileNo,
  }) async {
    try {
      User user = User(
        name: name,
        lastName: lastName,
        password: password,
        mobileNo: mobileNo,
        emailId: email,
        address: '',
        type: '',
        token: '',
        id: '',
      );

      http.Response res = await http.post(
        Uri.parse('$uri/api/signup'),
        body: user.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(
            context,
            'Account created! Login with the same credentials!',
          );
        },
      );
    } catch (e) {
      print(e.toString());
      showSnackBar(context, e.toString());
    }
  }

  // sign in user
  void signInUser({
    required BuildContext context,
    required String mobileNo,
    required String password,
  }) async {
    try {
      final customerRes = await http.post(
        Uri.parse('$uri/login/customer'),
        body: jsonEncode({
          'mobileId': mobileNo,
          'password': password,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      int code = customerRes.statusCode;
      print('??$code');
      if (customerRes.statusCode == 202) {
        final customerResponseJson = jsonDecode(customerRes.body);
        final customerToken = customerResponseJson['token'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        Provider.of<UserProvider>(context, listen: false)
            .setUser(customerRes.body);
        await prefs.setString('x-auth-token', customerToken);
        await prefs.setString('user-type', 'customer');
        httpErrorHandle(
          response: customerRes,
          context: context,
          onSuccess: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            Provider.of<UserProvider>(context, listen: false)
                .setUser(customerRes.body);
            await prefs.setString('x-auth-token', customerToken);

            Navigator.pushNamed(context, '/actual-home');
          },
        );
      }
      if (customerRes.statusCode == 202) {
        Navigator.pushNamed(context, '/actual-home');
      } else {
        print('?sELER API?$code');

        final sellerRes = await http.post(
          Uri.parse('$uri/login/seller'),
          body: jsonEncode({
            'mobile': mobileNo,
            'password': password,
          }),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );
        code = sellerRes.statusCode;

        print('?SELLER CODE?$code');

        if (sellerRes.statusCode == 202) {
          final sellerResponseJson = jsonDecode(sellerRes.body);
          final sellerToken = sellerResponseJson['token'];

          SharedPreferences prefs = await SharedPreferences.getInstance();
          Provider.of<UserProvider>(context, listen: false)
              .setUser(sellerRes.body);
          await prefs.setString('x-auth-token', sellerToken);
          await prefs.setString('user-type', 'seller');

          httpErrorHandle(
            response: sellerRes,
            context: context,
            onSuccess: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              /*   Provider.of<UserProvider>(context, listen: false)
                  .setUser(sellerRes.body);*/
              await prefs.setString('x-auth-token', sellerToken);
              Navigator.pushNamed(context, '/admin-home');

              // Navigate to the seller screen
            },
          );
        }
        if (sellerRes.statusCode == 202) {
          Navigator.pushNamed(context, '/admin-home');
        } else {
          // Handle other status codes or errors for both customer and seller login
        }
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // get user data
  void getUserData(
    BuildContext context,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token == null) {
        prefs.setString('x-auth-token', '');
      }
      print(token);

      var tokenRes = await http.get(
        Uri.parse('$uri/customer/current'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'token': token!
        },
      );

      var response = tokenRes.body;
      print(tokenRes.body);
      if (tokenRes.statusCode == 200) {
        http.Response userRes = await http.get(
          Uri.parse('$uri/customer/current'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'token': token
          },
        );

        var userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(userRes.body);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<bool> checkTokenLoggedIn(String token) async {
    var url = Uri.parse('$uri/customer/current');
    var headers = {'token': token};
    var sellerurl = Uri.parse('$uri/seller/current');

    try {
      var response = await http.get(url, headers: headers);
      var selleresponse = await http.get(sellerurl, headers: headers);

      if (response.statusCode == 202) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        //prefs.setString('looged', 'true');
        // Token is logged in
        return true;
      } else if (selleresponse.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // Error occurred during API call
      print('Error: $e');
      return false;
    }
  }

  Future<void> toHomeScreen(
    BuildContext context,
  ) async {
    getUserData(context);

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String token = userProvider.user.token;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? action = prefs.getString('x-auth-token');

    bool isLoggedIn = await checkTokenLoggedIn(action.toString());

    Widget w;
    if (isLoggedIn == true) {
      // Navigator.pushNamed(context, '/actual-home');
    } else {
      //Navigator.pushNamed(context, '/auth-screen');
    }
  }

  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? action = prefs.getString('x-auth-token');
    if (action == null) {
      action = '';
    }
    return action;
  }

  Future<bool> isLogged() async {
    String action = await getToken();
    bool isLoggedIn = await checkTokenLoggedIn(action.toString());
    if (isLoggedIn) {
      print("Logged IN ");
      return true;
    }
    print('not logged');

    return false;
  }
}
