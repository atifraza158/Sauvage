import 'dart:io';

import 'package:dine_in/Views/UserSide/DrawerScreens/user_drawer_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../Views/AuthScreens/login_screen.dart';

class FirebaseServices {
  bool loader = false;
  FirebaseAuth auth = FirebaseAuth.instance;

  login(BuildContext context, String email, String password) async {
    try {
      loader = true;
      await auth
          .signInWithEmailAndPassword(
            email: email,
            password: password,
          )
          .then((value) => {
                loader = false,
                Fluttertoast.showToast(msg: "Login Successfully"),
                Get.offAll(UserDrawerScreen()),
              });
    } on SocketException catch (_) {
      Fluttertoast.showToast(msg: 'Please Connect to internet');
    } catch (e) {
      loader = false;
      Fluttertoast.showToast(msg: "Error While login");
      debugPrint(e.toString());
    }
  }

  register(BuildContext context, String name, String email, String no,
      String password) async {
    try {
      auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        Fluttertoast.showToast(msg: 'Account Created Successfully');

        Get.offAll(LoginScreen());
      }).onError((error, stackTrace) {
        Fluttertoast.showToast(msg: error.toString());
      });
    } on SocketException catch (_) {
      Fluttertoast.showToast(msg: 'No Internet Connection');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut().then((value) => {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return LoginScreen();
            },
          )),
        });
  }
}
