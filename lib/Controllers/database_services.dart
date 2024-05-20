import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dine_in/Views/AdminSide/AdminDrawer/admin_drawer_screen.dart';
import 'package:dine_in/Views/AdminSide/ItemsScreens/all_items_admin.dart';
import 'package:dine_in/Views/AuthScreens/auth_check.dart';
import 'package:dine_in/Views/UserSide/DrawerScreens/user_drawer_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../Views/AuthScreens/login_screen.dart';

class DatabaseServices extends GetxController {
  RxBool loader = false.obs;
  Future addData(
      Map<String, dynamic> data, String id, String collectionName) async {
    try {
      loader = true.obs;
      update();
      return await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(id)
          .set(data)
          .then((value) {
        loader = false.obs;
        update();
      });
    } catch (e) {
      loader = false.obs;
      update();
      print(e.toString());
    }
  }

  Future<Stream<QuerySnapshot>> getData(String collectionName) async {
    return FirebaseFirestore.instance.collection(collectionName).snapshots();
  }

  // Future UpdateItem(String id, Map<String, dynamic> itemDetails) async {
  //   return await FirebaseFirestore.instance
  //       .collection('items')
  //       .doc(id)
  //       .update(itemDetails);
  // }
  Future UpdateItem(String id, Map<String, dynamic> itemDetails) async {
    final docRef = FirebaseFirestore.instance.collection('items').doc(id);
    final doc = await docRef.get();

    if (doc.exists) {
      return await docRef.update(itemDetails);
    } else {
      // Handle the case when the document doesn't exist
      print('Document does not exist');
    }
  }

  Future deleteData(String id, String collectionName) async {
    return await FirebaseFirestore.instance
        .collection(collectionName)
        .doc(id)
        .delete()
        .then((value) {
      Fluttertoast.showToast(msg: "Item Deleted Successfully");
      Get.off(() => AllItemsAdmin());
    }).onError((error, stackTrace) {
      Fluttertoast.showToast(msg: 'Error While Deleting the item');
      print(error);
    });
  }

  // Here are the Auth Services below

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

  logOut() async {
    await FirebaseAuth.instance.signOut().then((value) {
      Fluttertoast.showToast(msg: 'Logout Successfully');
      Get.offAll(() => LoginScreen());
    });
  }
}
