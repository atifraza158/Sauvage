import 'package:dine_in/Views/AuthScreens/login_screen.dart';
import 'package:dine_in/Views/UserSide/DrawerScreens/user_drawer_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  State<AuthCheck> createState() => AuthCheckState();
}

class AuthCheckState extends State<AuthCheck> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return UserDrawerScreen();
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
