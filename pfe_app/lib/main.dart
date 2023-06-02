import 'package:flutter/material.dart';
import 'package:pfe_app/features/auth/screens/login.dart';
import 'package:pfe_app/features/auth/services/auth_service.dart';
import 'package:pfe_app/features/welcome/welcome.dart';
import 'package:pfe_app/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'common/widgets/admin_bottom_bar.dart';
import 'common/widgets/bottom_bar.dart';
import 'constants/global_variables.dart';
import 'constants/routes.dart';

void main() {
  String ipAddress =
      '192.168.137.25'; // Replace with the IP address of your Android device

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => UserProvider(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  static const String routeName = '/main-screen';

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Store',
      theme: ThemeData(
        scaffoldBackgroundColor: GlobalVariables.backgroundColor,
        colorScheme: const ColorScheme.light(
          primary: GlobalVariables.secondaryColor,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
        ),
        useMaterial3: true, // can remove this line
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: FutureBuilder<bool>(
        future: checkLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Display a loading indicator while checking authentication status
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            if (snapshot.hasData && snapshot.data!) {
              return FutureBuilder<String?>(
                future: getType(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Display a loading indicator while fetching the user type
                    return Scaffold(
                      body: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else {
                    if (snapshot.hasData) {
                      String? userType = snapshot.data;
                      if (userType == 'seller') {
                        return AdminScreen();
                      } else if (userType == 'customer') {
                        return BottomBar();
                      }
                    }
                    // User is not logged in or userType is not 'seller' or 'customer',
                    // navigate to the login screen
                    return Login();
                  }
                },
              );
            } else {
              // User is not logged in, navigate to the login screen
              return Login();
            }
          }
        },
      ),
    );
  }

  Future<bool> checkLoggedIn() async {
    final AuthService authService = AuthService();
    bool isLoggedIn = await authService.isLogged();
    return isLoggedIn;
  }

  Future<String?> getType() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? action = prefs.getString('user-type');
    return action;
  }
}
