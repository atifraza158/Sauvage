import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

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

  Future<bool> doesEmailExist(String email) async {
    final firestore = FirebaseFirestore.instance;

    // Create a query to check for documents where 'email' field matches
    final query = await firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    // Check if any documents were found
    return query.docs.isNotEmpty;
  }
}
