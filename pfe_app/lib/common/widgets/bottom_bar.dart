import 'package:flutter/material.dart';
import 'package:pfe_app/admin/screens/add_product_screen.dart';
import 'package:pfe_app/admin/screens/posts_screen.dart';
import 'package:pfe_app/constants/global_variables.dart';
import 'package:pfe_app/features/account/screens/account_screen.dart';
import 'package:pfe_app/features/auth/services/auth_service.dart';
import 'package:pfe_app/features/scanner/screens/qr_scanner_screen%20.dart';
//import 'package:pfe_app/features/cart/screens/cart_screen.dart';
import 'package:pfe_app/features/welcome/welcome.dart';
import 'package:pfe_app/home/screens/home_screen.dart';
import 'package:pfe_app/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as Badge;
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/cart/cartv2/cart_screen2.dart';

class BottomBar extends StatefulWidget {
  static const String routeName = '/actual-home';
  const BottomBar({Key? key}) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _page = 0;
  double bottomBarWidth = 42;
  double bottomBarBorderWidth = 5;

  List<Widget> pages = [
    const HomeScreen(),
    const PostsScreen(),
    CartScreen(),
    //const CartScreen(),
  ];

  void updatePage(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  void initState() {
    _checkUserLoggedIn(context);
    print('00000');

    super.initState();
  }

  Future<void> _checkUserLoggedIn(context) async {
    print('00000');
    final authService = AuthService();
    String action = await getToken();
    bool isLoggedIn = await authService.checkTokenLoggedIn(action.toString());

    bool actions = await authService.isLogged();
    //print('0$isLoggedIn');
    if (isLoggedIn == false) {
      print(":0 ");
      Navigator.pushNamed(context, '/auth-screen');
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

  @override
  Widget build(BuildContext context) {
    final userCartLen = 0;

    return Scaffold(
      body: pages[_page],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _page,
        selectedItemColor: GlobalVariables.selectedNavBarColor,
        unselectedItemColor: GlobalVariables.unselectedNavBarColor,
        backgroundColor: GlobalVariables.backgroundColor,
        iconSize: 28,
        onTap: updatePage,
        items: [
          // HOME
          BottomNavigationBarItem(
            icon: Container(
              width: bottomBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: _page == 0
                        ? GlobalVariables.selectedNavBarColor
                        : GlobalVariables.backgroundColor,
                    width: bottomBarBorderWidth,
                  ),
                ),
              ),
              child: const Icon(
                Icons.home_outlined,
              ),
            ),
            label: '',
          ),
          // ACCOUNT
          BottomNavigationBarItem(
            icon: Container(
              width: bottomBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: _page == 1
                        ? GlobalVariables.selectedNavBarColor
                        : GlobalVariables.backgroundColor,
                    width: bottomBarBorderWidth,
                  ),
                ),
              ),
              child: const Icon(
                Icons.person_outline_outlined,
              ),
            ),
            label: '',
          ),
          // CART
          BottomNavigationBarItem(
            icon: Container(
              width: bottomBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: _page == 2
                        ? GlobalVariables.selectedNavBarColor
                        : GlobalVariables.backgroundColor,
                    width: bottomBarBorderWidth,
                  ),
                ),
              ),
              child: const Icon(
                Icons.shopping_cart_outlined,
              ),
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
