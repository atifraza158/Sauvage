import 'dart:async';

import 'package:dine_in/Views/AuthScreens/auth_check.dart';
import 'package:dine_in/Views/Utils/Styles/theme.dart';
import 'package:flutter/material.dart';
import 'Utils/Styles/text_styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) {
          return AuthCheck();
          // return LoginScreen();
        },
      ));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.themeColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Savauge",
                  style: CustomTextStyles.splashTitle,
                ),
                Text(
                  "We know youe taste",
                  style: CustomTextStyles.mediumWhiteColorStyle,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
