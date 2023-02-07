import 'package:quizapp/about/about.dart';
import 'package:quizapp/email/auth_page.dart';
import 'package:quizapp/email/email.dart';
import 'package:quizapp/email/forgot_password.dart';
import 'package:quizapp/email/signUp.dart';
import 'package:quizapp/profile/profile.dart';
import 'package:quizapp/login/login.dart';
import 'package:quizapp/topics/topics.dart';
import 'package:quizapp/home/home.dart';

var appRoutes = {
  '/': (context) => const HomeScreen(),
  '/login': (context) => const LoginScreen(),
  '/topics': (context) => const TopicsScreen(),
  '/profile': (context) => const ProfileScreen(),
  '/about': (context) => const AboutScreen(),
  '/authpage': (context) => const AuthPage(),
  '/forgotpassword': (context) => const ForgotPaswordScreen()
};
