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
            (value) => loader(true),
          );
    } catch (e) {
      print(e.toString());
      loader(true);
    }
  }

  Future<Stream<QuerySnapshot>> getData(String collectName) async {
    return FirebaseFirestore.instance.collection(collectName).snapshots();
  }
}
