import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dine_in/Views/AdminSide/AdminDrawer/admin_drawer_screen.dart';
import 'package:dine_in/Views/AuthScreens/auth_check.dart';
import 'package:dine_in/Views/UserSide/DrawerScreens/user_drawer_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../Views/AuthScreens/login_screen.dart';

class DatabaseServices extends GetxController {
  RxBool loader = false.obs;
  Future addData(
      Map<String, dynamic> data, String id, String collectionName) async {
    loader(true);
    try {
      return await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(id)
          .set(data)
          .then(
            (value) => loader(false),
          );
    } catch (e) {
      print(e.toString());
      loader(false);
    }
  }

  Future<Stream<QuerySnapshot>> getData(String collectName) async {
    return FirebaseFirestore.instance.collection(collectName).snapshots();
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      loader(true);
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      loader(false);
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await firestore.collection('auth').doc(user!.uid).get();
      final String role = documentSnapshot['role'];
      // Navigate based on the user's role
      if (documentSnapshot['role'] == 'admin') {
        Get.offAll(() => AdminDrawerScreen());
      } else if (role == 'user') {
        Get.offAll(() => UserDrawerScreen());
      }
      Get.offAll(() => AuthCheck());
      print(user);
    } catch (e) {
      loader(false);
      Get.snackbar('Error', 'User Not Found');
      print('Error: $e');
    }
  }

  Future<void> createUserWithEmailAndPassword(
      String email, String password, String name) async {
    try {
      loader(true);
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      await FirebaseFirestore.instance.collection('auth').doc(user!.uid).set({
        'email': email,
        'name': name,
        'role': 'user',
      }).then((value) {
        loader(false);
        Get.snackbar('Success', "User Created Successfully");
        Get.offAll(() => LoginScreen());
      });
    } catch (e) {
      print('Error: $e');
      loader(false);
    }
  }
}
