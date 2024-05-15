import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dine_in/Views/AdminSide/AdminDrawer/admin_drawer_screen.dart';
import 'package:dine_in/Views/AuthScreens/login_screen.dart';
import 'package:dine_in/Views/UserSide/DrawerScreens/user_drawer_screen.dart';
import 'package:dine_in/Views/Utils/Styles/theme.dart';
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
          final User? user = snapshot.data;
          final String uid = user!.uid;
          final FirebaseFirestore firestore = FirebaseFirestore.instance;
          final DocumentReference documentReference =
              firestore.collection('auth').doc(uid);
          return StreamBuilder(
            stream: documentReference.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final DocumentSnapshot<Object?>? documentSnapshot =
                    snapshot.data;
                final String role = documentSnapshot!['role'];
                if (role == 'admin') {
                  return AdminDrawerScreen();
                } else {
                  return UserDrawerScreen();
                }
              } else {
                return Center(
                    child: CircularProgressIndicator(
                  color: AppTheme.themeColor,
                ));
              }
            },
          );
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
