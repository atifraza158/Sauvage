import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dine_in/Controllers/cart_controller.dart';
import 'package:dine_in/Views/Utils/Styles/theme.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../Utils/Components/login_button.dart';
import '../../Utils/Styles/text_styles.dart';

class ItemDetailUser extends StatefulWidget {
  final String id;
  const ItemDetailUser({
    super.key,
    required this.id,
  });

  @override
  State<ItemDetailUser> createState() => _ItemDetailUserState();
}

class _ItemDetailUserState extends State<ItemDetailUser> {
  CartController cartController = Get.put(CartController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Item Detail",
          style: CustomTextStyles.appBarStyle,
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('items')
            .doc(widget.id)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            DocumentSnapshot<Map<String, dynamic>>? ds = snapshot.data;
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
                          '${ds!['image']}',
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
                          SizedBox(height: 10),
                          Text(
                            "Description",
                            style: CustomTextStyles.mediumBlackColorStyle,
                          ),
                          Text(
                            '${ds['description']}',
                            style: CustomTextStyles.smallGreyColorStyle,
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
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: CommonButton(
          child: Obx(
            () => cartController.loader.isTrue
                ? Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.whiteColor,
                    ),
                  )
                : Text(
                    "Add to Cart",
                    style: CustomTextStyles.commonButtonStyle,
                  ),
          ),
          onPressed: () {
            cartController.addItemToCart(widget.id).then((value) {
              Fluttertoast.showToast(msg: 'item added to cart');
            }).onError((error, stackTrace) {
              print(error);
            });
          },
        ),
      ),
    );
  }
}
