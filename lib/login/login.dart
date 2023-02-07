import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quizapp/services/auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            const FlutterLogo(
              size: 150,
            ),
            LoginButton(
              color: Colors.blue,
              iconData: FontAwesomeIcons.google,
              loginMethod: AuthService().googleLogin,
              text: 'Sign in with google',
            ),
            LoginButton(
              color: Colors.black,
              iconData: FontAwesomeIcons.envelope,
              loginMethod: () {
                Navigator.pushNamed(context, '/authpage');
              },
              text: 'Sign in with email',
            ),
            Flexible(
              child: LoginButton(
                color: Colors.deepPurple,
                iconData: FontAwesomeIcons.userNinja,
                loginMethod: AuthService().anonLogin,
                text: 'Continue as guest',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  final Color color;
  final IconData iconData;
  final String text;
  final Function loginMethod;

  const LoginButton(
      {super.key,
      required this.color,
      required this.iconData,
      required this.text,
      required this.loginMethod});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: ElevatedButton.icon(
        icon: Icon(
          iconData,
          color: Colors.white,
          size: 20,
        ),
        onPressed: () => loginMethod(),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(24),
          backgroundColor: color,
        ),
        label: Text(text),
      ),
    );
  }
}
