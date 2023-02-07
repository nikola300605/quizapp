import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quizapp/shared/utils.dart';

class SignUpScreen extends StatefulWidget {
  final Function() onClickedSignIn;
  const SignUpScreen({super.key, required this.onClickedSignIn});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Sign up", style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 40),
              TextFormField(
                controller: emailController,
                cursorColor: Colors.white,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(labelText: 'Email'),
                obscureText: false,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (email) =>
                    email != null && !EmailValidator.validate(email)
                        ? 'Enter a valid email'
                        : null,
              ),
              SizedBox(height: 4),
              TextFormField(
                controller: passwordController,
                cursorColor: Colors.white,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (password) => password != null &&
                        password.length >= 6 &&
                        !password.contains(RegExp(r'[A-Z]'))
                    ? 'A password must have at least 6 letters and 1 uppercase letter'
                    : null,
              ),
              SizedBox(height: 4),
              TextFormField(
                cursorColor: Colors.white,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (password) => password != passwordController.text
                    ? 'Your passwords do not match'
                    : null,
              ),
              SizedBox(height: 20),
              SignInButton(
                color: const Color.fromARGB(255, 14, 83, 50),
                iconData: FontAwesomeIcons.unlock,
                text: "Sign Up",
                loginMethod: signUp,
              ),
              SizedBox(height: 24),
              RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.white),
                  text: "Already have an account? ",
                  children: [
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = widget.onClickedSignIn,
                      text: 'Log In',
                      style: const TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      if (!context.mounted) return;
      Navigator.pushNamed(context, '/verifyemail');
    } on FirebaseAuthException catch (e) {
      print(e);
      Navigator.of(context).pop();
      Utils.showSnackBar(e.message);
    }
  }
}

class SignInButton extends StatelessWidget {
  final Color color;
  final IconData iconData;
  final String text;
  final Function loginMethod;

  const SignInButton(
      {super.key,
      required this.color,
      required this.iconData,
      required this.text,
      required this.loginMethod});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
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
