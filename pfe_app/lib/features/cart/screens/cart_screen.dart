import 'package:flutter/material.dart';
import 'package:pfe_app/common/widgets/custom_button.dart';
import 'package:pfe_app/common/widgets/loader.dart';
import 'package:pfe_app/constants/global_variables.dart';
import 'package:pfe_app/features/account/widgets/single_product.dart';
import 'package:pfe_app/features/cart/services/cart_services.dart';
import 'package:pfe_app/features/cart/widgets/cart_product.dart';
import 'package:pfe_app/features/product_details/services/product_details_services.dart';
import 'package:pfe_app/features/search/screens/search_screen.dart';
import 'package:pfe_app/models/CartItem.dart';
import 'package:pfe_app/models/userr.dart';
import 'package:pfe_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  List<CartItem>? products;

  final ProductDetailsServices productDetailsServices =
      ProductDetailsServices();
  final CartServices cartServices = CartServices();

  @override
  void initState() {
    super.initState();
    fetchAllProducts();
    // print(cartServices.fetchAllProducts(context));
    print('teest$products');
  }

  /* void navigateToAddress(int sum) {
    Navigator.pushNamed(
      context,
      AddressScreen.routeName,
      arguments: sum.toString(),
    );
  }*/

  Future<void> fetchAllProducts() async {
    products = await cartServices.getCartProduct(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return products == null
        ? const Loader()
        : Scaffold(
            body: GridView.builder(
              itemCount: products!.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemBuilder: (context, index) {
                final productData = products![index];
                print('WAAAAAAAAAAAAAAAAAA3333 $productData');
                return Column(
                  children: [
                    SizedBox(
                      height: 140,
                      child: SingleProduct(
                        image: productData.cartProduct.images[0],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Text(
                            productData.cartProduct.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          // () => deleteProduct(productData, index),
                          icon: const Icon(
                            Icons.delete_outline,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {},
              //navigateToAddProduct,
              tooltip: 'Add a Product',
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
