import 'package:flutter/material.dart';
import 'package:pfe_app/common/widgets/bottom_bar.dart';
import 'package:pfe_app/features/auth/screens/signup.dart';
import 'package:pfe_app/widgets/top_titles/top_titles.dart';
import 'package:pfe_app/constants/routes.dart';
import '../../widgets/primary_buttons/primary_button.dart';
import 'package:pfe_app/features/auth/screens/login.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});
  static const String routeName = '/Welcome-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*const TopTitles(
                subtitle: "Buy AnyItems From Using App ", title: "Welcome"
                ),*/
            Center(
              child: Image.asset("assets/images/welcome.png"),
            ),
            const SizedBox(
              height: 30.0,
            ),
            PrimaryButton(
              title: "Login",
              onPressed: () {
                Routes.instance.push(widget: const Login(), context: context);
              },
            ),
            const SizedBox(
              height: 18.0,
            ),
            PrimaryButton(
              title: "Sign Up",
              onPressed: () {
                Routes.instance.push(widget: const SignUp(), context: context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
/*import 'package:flutter/material.dart';

class login extends StatelessWidget {
  
  const login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Text("Welcome"),
          const SizedBox(
            height: 12,
          )
        ]),
    )
  }
}*/