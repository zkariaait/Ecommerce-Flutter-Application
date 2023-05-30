import 'package:flutter/material.dart';
import 'package:pfe_app/common/widgets/loader.dart';
import 'package:pfe_app/features/account/widgets/single_product.dart';
import 'package:pfe_app/features/cart/services/cart_services.dart';
import 'package:pfe_app/features/product_details/services/product_details_services.dart';
import 'package:pfe_app/models/CartItem.dart';
import 'package:pfe_app/models/product.dart';
import 'package:pfe_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class CartProduct extends StatefulWidget {
  final int index;

  const CartProduct({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  State<CartProduct> createState() => _CartProductState();
}

class _CartProductState extends State<CartProduct> {
  List<CartItem>? products;

  final ProductDetailsServices productDetailsServices =
      ProductDetailsServices();
  final CartServices cartServices = CartServices();

  @override
  void initState() {
    super.initState();
    fetchAllProducts();
  }

  void increaseQuantity(CartItem product) {
    /* productDetailsServices.addToCart(
      context: context,
      product: product,
    );*/
  }

  void decreaseQuantity(CartItem product) {
    /* cartServices.removeFromCart(
      context: context,
      product: product,
    );*/
  }

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
