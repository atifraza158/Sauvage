import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dine_in/Controllers/cart_controller.dart';
import 'package:dine_in/Views/UserSide/checkout.dart';
import 'package:dine_in/Views/Utils/Components/login_button.dart';
import 'package:dine_in/Views/Utils/Styles/text_styles.dart';
import 'package:dine_in/Views/Utils/Styles/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  User? currentUser;
  CartController cartController = Get.put(CartController());
  var cartLength = 0;
  List<dynamic> items = [];
  List<dynamic> deals = [];

  checkUser() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        currentUser = user;
      });
    });
  }

  @override
  void initState() {
    checkUser();
    super.initState();
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
      body: items.isEmpty && deals.isEmpty
          ? Center(
              child: Text("No items Added to Cart"),
            )
          : StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('carts')
                  .doc(currentUser!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    Map<String, dynamic>? ds = snapshot.data!.data();
                    items = ds!['items'];
                    deals = ds['deals'];
                    print(deals);
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: ds!['items'].length,
                              itemBuilder: (context, index) {
                                return StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('items')
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      DocumentSnapshot document =
                                          snapshot.data!.docs[index];

                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: AppTheme.themeColor,
                                            borderRadius:
                                                BorderRadius.circular(14),
                                            boxShadow: [
                                              BoxShadow(
                                                color: AppTheme.greyColor
                                                    .withOpacity(0.5),
                                                blurRadius: 4,
                                                offset: Offset(4, 8),
                                              ),
                                            ],
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ListTile(
                                              leading: CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    document['image']),
                                              ),
                                              title: Text(
                                                document['title'],
                                                style: CustomTextStyles
                                                    .smallWhiteColorStyle,
                                              ),
                                              subtitle: Text(
                                                "\$" + document['price'],
                                                style: CustomTextStyles
                                                    .smallWhiteColorStyle,
                                              ),
                                              trailing: IconButton(
                                                  onPressed: () {},
                                                  icon: Icon(
                                                    Icons.delete,
                                                    color: AppTheme.whiteColor,
                                                  )),
                                            ),
                                          ),
                                        ),
                                      );
                                    } else {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                  },
                                );
                              },
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: ds['deals'].length,
                              itemBuilder: (context, index) {
                                return StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('deals')
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      DocumentSnapshot document =
                                          snapshot.data!.docs[index];
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: AppTheme.themeColor,
                                            borderRadius:
                                                BorderRadius.circular(14),
                                            boxShadow: [
                                              BoxShadow(
                                                color: AppTheme.greyColor
                                                    .withOpacity(0.5),
                                                blurRadius: 4,
                                                offset: Offset(4, 8),
                                              ),
                                            ],
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ListTile(
                                              leading: CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    document['image']),
                                              ),
                                              title: Text(
                                                document['title'],
                                                style: CustomTextStyles
                                                    .smallWhiteColorStyle,
                                              ),
                                              subtitle: Text(
                                                "\$" + document['price'],
                                                style: CustomTextStyles
                                                    .smallWhiteColorStyle,
                                              ),
                                              trailing: IconButton(
                                                  onPressed: () {},
                                                  icon: Icon(
                                                    Icons.delete,
                                                    color: AppTheme.whiteColor,
                                                  )),
                                            ),
                                          ),
                                        ),
                                      );
                                    } else {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.themeColor,
                      ),
                    );
                  }
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.themeColor,
                    ),
                  );
                }
              },
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: CommonButton(
          child: Text(
            "CheckOut",
            style: CustomTextStyles.commonButtonStyle,
          ),
          onPressed: () {
            Get.to(() => CheckOutScreen(
                  items: items,
                  deals: deals,
                ));
          },
        ),
      ),
    );
  }
}
