import 'package:flutter/material.dart';
import 'package:pfe_app/features/auth/screens/login.dart';
import 'package:pfe_app/features/auth/services/auth_service.dart';
import 'package:pfe_app/features/welcome/welcome.dart';
import 'package:pfe_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

import 'common/widgets/bottom_bar.dart';
import 'constants/global_variables.dart';
import 'constants/routes.dart';

void main() {
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
              // User is logged in, navigate to the home screen (BottomBar)
              return BottomBar();
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
}


/*import 'package:flutter/material.dart';
import 'package:pfe_app/features/auth/screens/login.dart';
import 'package:pfe_app/features/auth/services/auth_service.dart';
import 'package:pfe_app/features/welcome/welcome.dart';
import 'package:pfe_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

import 'common/widgets/bottom_bar.dart';
import 'constants/global_variables.dart';
import 'constants/routes.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
    ),
  ], child: const MyApp()));
}

@override
class MyApp extends StatefulWidget {
  static const String routeName = '/main-screen';

  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    
    authService.getUserData(context);
  }

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
          elevation: 00,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
        ),
        useMaterial3: true, // can remove this line
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: Provider.of<UserProvider>(context).user.token.isNotEmpty
          ? const BottomBar()
          : const Login(),
    );
  }
}
*/