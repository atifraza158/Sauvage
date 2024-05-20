import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dine_in/Controllers/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../Utils/Components/login_button.dart';
import '../../Utils/Styles/text_styles.dart';

class DealDetailUser extends StatefulWidget {
  final String id;
  const DealDetailUser({
    super.key,
    required this.id,
  });

  @override
  State<DealDetailUser> createState() => _DealDetailUserState();
}

class _DealDetailUserState extends State<DealDetailUser> {
  CartController cartController = Get.put(CartController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Deal Detail",
          style: CustomTextStyles.appBarStyle,
        ),
      ),
      body: getAllDealsWidget(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: CommonButton(
          child: Text(
            "Add to Cart",
            style: CustomTextStyles.commonButtonStyle,
          ),
          onPressed: () {
            cartController.addDealToCart(widget.id).then((value) {
              Fluttertoast.showToast(msg: "Deal added to cart");
            });
          },
        ),
      ),
    );
  }

  Widget getAllDealsWidget() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('deals')
          .doc(widget.id)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          DocumentSnapshot<Map<String, dynamic>>? ds = snapshot.data;
          var itemIds = List<dynamic>.from(ds!['items']);
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.network(
                        width: MediaQuery.sizeOf(context).width,
                        '${ds['image']}',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, top: 25, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '${ds['title']}',
                          style: CustomTextStyles.appBarStyle,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Price",
                              style: CustomTextStyles.mediumBlackColorStyle2,
                            ),
                            Text(
                              '\$${ds['price']}',
                              style: CustomTextStyles.mediumBlackColorStyle2,
                            ),
                          ],
                        ),
                        SizedBox(height: 40),
                        Text(
                          "Description",
                          style: CustomTextStyles.mediumBlackColorStyle,
                        ),
                        Text(
                          '${ds['description']}',
                          style: CustomTextStyles.smallGreyColorStyle,
                        ),
                        itemIds.isNotEmpty
                            ? SizedBox(
                                height: 300,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: itemIds.length,
                                  itemBuilder: (context, index) {
                                    return FutureBuilder(
                                      future: FirebaseFirestore.instance
                                          .collection('items')
                                          .doc(itemIds[index])
                                          .get(),
                                      builder: (context, itemSnapshot) {
                                        if (itemSnapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        } else if (itemSnapshot.hasData) {
                                          var itemData =
                                              itemSnapshot.data!.data();
                                          return ListTile(
                                            leading: CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  itemData!['image']),
                                            ),
                                            title: Text(itemData['title']),
                                          );
                                        } else {
                                          return Center(
                                            child: Text(
                                              'Error loading item data',
                                            ),
                                          );
                                        }
                                      },
                                    );
                                  },
                                ),
                              )
                            : Center(
                                child: Text(
                                  'No items found',
                                  style: CustomTextStyles.smallGreyColorStyle,
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
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
  }
}
