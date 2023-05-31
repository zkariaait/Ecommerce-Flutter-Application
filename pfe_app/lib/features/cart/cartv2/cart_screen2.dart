import 'package:flutter/material.dart';
import 'package:pfe_app/features/cart/cartv2/components/check_out_card.dart';

import 'components/body.dart';

class CartScreen extends StatelessWidget {
  static String routeName = "/cart";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Body(),
      bottomNavigationBar: CheckoutCard(),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Column(
        children: [
          Text(
            "Your Cart",
            style: TextStyle(color: Colors.black),
          ),
          Text(
            "XXXX items",
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );
  }
}
