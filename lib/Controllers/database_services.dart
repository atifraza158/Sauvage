import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseServices {
  bool loader = false;
  Future addData(Map<String, dynamic> categoryDetails, String id,
      String collectionName) async {
    loader = true;
    try {
      return await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(id)
          .set(categoryDetails)
          .then(
            (value) => loader = false,
          );
    } catch (e) {
      print(e.toString());
      loader = false;
    }
  }

  Future<Stream<QuerySnapshot>> getData(String collectName) async {
    return FirebaseFirestore.instance.collection(collectName).snapshots();
  }
}
