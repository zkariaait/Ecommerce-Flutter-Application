import 'package:flutter/material.dart';
import 'package:pfe_app/features/cart/cartv2/components/check_out_card.dart';
import 'package:pfe_app/features/cart/services/cart_services.dart';
import 'package:pfe_app/models/CartItem.dart';

import 'components/body.dart';

class CartScreen extends StatefulWidget {
  static String routeName = "/cart";

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CartItem> products = []; // List to store the fetched products
  final CartServices cartServices = CartServices();

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    // Fetch products from the API using CartServices or any other method
    // Example:
    final fetchedProducts = await cartServices.getCartProduct(context);
    setState(() {
      products = fetchedProducts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, products.length),
      body: Body(),
      bottomNavigationBar: CheckoutCard(),
    );
  }

  AppBar buildAppBar(BuildContext context, int itemCount) {
    itemCount = products.length;
    return AppBar(
      title: Column(
        children: [
          Text(
            "Your Cart",
            style: TextStyle(color: Colors.black),
          ),
          Text(
            "$itemCount items",
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );
  }
}
