// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quizapp/services/auth.dart';
import 'package:quizapp/shared/utils.dart';
import 'package:quizapp/topics/topics.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool isEmailVerified = false;
  Timer? timer;
  @override
  void initState() {
    isEmailVerified = AuthService().user!.emailVerified;
    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(
        Duration(seconds: 3),
        (_) => Future.delayed(Duration.zero, () async {
          checkEmailVerified();
        }),
      );
    }
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future sendVerificationEmail() async {
    try {
      final user = AuthService().user!;
      await user.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message);
    }
  }

  Future checkEmailVerified() async {
    await AuthService().user!.reload();

    setState(() {
      isEmailVerified = AuthService().user!.emailVerified;
    });

    if (isEmailVerified) timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'A verification email has been sent, please confirm your email.',
              style: TextStyle(
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              icon: Icon(FontAwesomeIcons.envelope, size: 32),
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: const Color.fromARGB(255, 14, 83, 50)),
              label: Text(
                'Confirm',
                style: TextStyle(fontSize: 24),
              ),
              onPressed: () => isEmailVerified
                  ? Navigator.of(context)
                      .pushNamedAndRemoveUntil('/', (route) => false)
                  : Utils.showSnackBar('You have not confirmed your email'),
            )
          ],
        ),
      ),
    );
  }
}
