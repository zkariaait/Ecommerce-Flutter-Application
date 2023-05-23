import 'package:flutter/material.dart';
import 'package:pfe_app/admin/screens/add_product_screen.dart';
import 'package:pfe_app/features/auth/screens/login.dart';
<<<<<<< Updated upstream
=======
import 'package:pfe_app/features/product_details/screens/product_details_screen.dart';
import 'package:pfe_app/features/search/screens/search_screen.dart';
>>>>>>> Stashed changes
import 'package:pfe_app/features/welcome/welcome.dart';
import 'package:pfe_app/common/widgets/bottom_bar.dart';
import 'package:pfe_app/home/screens/category_deals_screen.dart';
import 'package:pfe_app/home/screens/home_screen.dart';

import '../main.dart';

class Routes {
  static Routes instance = Routes();
  Future<dynamic> pushAndRemoveUntil(
      {required Widget widget, required BuildContext context}) {
    return Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (ctx) => widget), (route) => false);
  }

  Future<dynamic> push(
      {required Widget widget, required BuildContext context}) {
    return Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => widget),
    );
  }
}

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case Login.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Login(),
      );

    case MyApp.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const MyApp(),
      );
<<<<<<< Updated upstream

=======
    case SearchScreen.routeName:
      var searchQuery = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => SearchScreen(
          searchQuery: searchQuery,
        ),
      );
    case ProductDetailScreen.routeName:
      var product = routeSettings.arguments as Product;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => ProductDetailScreen(
          product: product,
        ),
      );
>>>>>>> Stashed changes
    case Welcome.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Welcome(),
      );

    case CategoryDealsScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const CategoryDealsScreen(
          category: 'mobiles',
        ),
      );

    case BottomBar.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const BottomBar(),
      );

    case HomeScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const HomeScreen(),
      );
    case BottomBar.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const BottomBar(),
      );
    case AddProductScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AddProductScreen(),
      );

    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Scaffold(
          body: Center(
            child: Text('Screen does not exist!'),
          ),
        ),
      );
  }
}
