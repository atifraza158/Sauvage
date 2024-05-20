import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  RxBool loader = false.obs;
  RxList<String> cartItems = <String>[].obs;

  Future<void> addItemToCart(String itemId) async {
    try {
      loader = true.obs;
      update();
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final cartRef =
          FirebaseFirestore.instance.collection('carts').doc(userId);
      // final itemRef = FirebaseFirestore.instance.collection('items').doc(itemId);

      await cartRef.get().then((cartDoc) {
        if (!cartDoc.exists) {
          cartRef.set({
            'items': [itemId]
          });
          loader(false);
        } else {
          cartRef.update({
            'items': FieldValue.arrayUnion([itemId])
          });
          loader(false);
        }
      });
    } catch (e) {
      print(e.toString());
      loader = false.obs;
      update();
    }
  }

  Future<Stream<QuerySnapshot>> getData(String collectName) async {
    return FirebaseFirestore.instance.collection(collectName).snapshots();
  }

  Future<void> fetchCartItems() async {
    try {
      loader(true);
      update();
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final cartRef =
          FirebaseFirestore.instance.collection('carts').doc(userId);

      final cartDoc = await cartRef.get();
      if (cartDoc.exists) {
        cartItems.value = List<String>.from(cartDoc['items']);
      } else {
        cartItems.clear();
      }
    } catch (e) {
      print(e.toString());
    } finally {
      loader(false);
      update();
    }
  }
}
