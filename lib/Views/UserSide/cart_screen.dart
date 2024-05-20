import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dine_in/Controllers/cart_controller.dart';
import 'package:dine_in/Views/Utils/Styles/text_styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  CartController cartController = Get.put(CartController());

  Stream? cartStream;
  User? currentUser;
  @override
  void initState() {
    super.initState();
    getUser();
    checkUser();
  }

  void getUser() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        currentUser = user;
      });
      if (currentUser != null) {
        getCartData(currentUser!.uid);
      }
    });
  }

  checkUser() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        currentUser = user;
      });
    });
  }

  void getCartData(String userId) {
    setState(() {
      cartStream = FirebaseFirestore.instance
          .collection('carts')
          .where('id', isEqualTo: userId)
          .snapshots();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Cart",
          style: CustomTextStyles.appBarStyle,
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('carts')
            .where('id', isEqualTo: currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            QuerySnapshot<Map<String, dynamic>>? cartData = snapshot.data;
            List<QueryDocumentSnapshot> documents = cartData!.docs;
            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                QueryDocumentSnapshot document = documents[index];

                return ListTile(
                  title: Text(document['title']),
                );
              },
            );
            // return Text('${cartData}');
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      // body: currentUser == null
      //     ? Center(
      //         child: CircularProgressIndicator(color: AppTheme.themeColor),
      //       )
      //     : StreamBuilder<QuerySnapshot>(
      //         stream: cartStream as Stream<QuerySnapshot>?,
      //         builder: (context, snapshot) {
      //           if (snapshot.connectionState == ConnectionState.waiting) {
      //             return Center(
      //               child:
      //                   CircularProgressIndicator(color: AppTheme.themeColor),
      //             );
      //           }
      //           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
      //             return Center(
      //               child: Text('Your cart is empty'),
      //             );
      //           }
      //           var documents = snapshot.data!.docs;
      //           return ListView.builder(
      //             itemCount: documents.length,
      //             itemBuilder: (context, index) {
      //               DocumentSnapshot ds = documents[index];
      //               return Container(
      //                 child: Text(ds['items'].toString()),
      //               );
      //             },
      //           );
      //         },
      //       ),
      // body: StreamBuilder(
      //   stream: cartStream,
      //   builder: (context, snapshot) {
      //     if (snapshot.hasData) {
      //       var documents = snapshot.data!.docs;
      //       return ListView.builder(
      //         itemCount: documents.length,
      //         itemBuilder: (context, index) {
      //           DocumentSnapshot ds = documents[index];
      //           return Container(
      //             child: Text(ds['items'].toString()),
      //           );
      //         },
      //       );
      //     } else {
      //       return Center(
      //         child: CircularProgressIndicator(
      //           color: AppTheme.themeColor,
      //         ),
      //       );
      //     }
      //   },
      // ),
    );
  }
}
