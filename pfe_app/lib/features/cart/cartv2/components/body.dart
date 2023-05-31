import 'package:flutter/material.dart';
import 'package:pfe_app/features/cart/services/cart_services.dart';
import 'package:pfe_app/features/product_details/services/product_details_services.dart';
import 'package:pfe_app/models/CartItem.dart';
import 'package:pfe_app/size_config.dart';

import 'cart_card.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<CartItem>? products;

  final ProductDetailsServices productDetailsServices =
      ProductDetailsServices();
  final CartServices cartServices = CartServices();

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    products = await cartServices.getCartProduct(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Initialize SizeConfig within the build method
    SizeConfig().init(context);

    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: ListView.builder(
        itemCount: products?.length ?? 0, // Use the null-aware operator
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Dismissible(
            key: Key(products![index].cartProduct.id.toString()),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              setState(() {
                products?.removeAt(index);
              });
            },
            background: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Color(0xFFFFE6E6),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Spacer(),
                  const Icon(
                    Icons.delete,
                  ),
                ],
              ),
            ),
            child: CartCard(cart: products![index]),
          ),
        ),
      ),
    );
  }
}
