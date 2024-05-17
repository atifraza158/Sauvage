import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dine_in/Views/UserSide/ItemsScreens/item_detail_User.dart';
import 'package:dine_in/Views/Utils/Styles/text_styles.dart';
import 'package:dine_in/Views/Utils/Styles/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/database_services.dart';

class AllItemsUser extends StatefulWidget {
  const AllItemsUser({super.key});

  @override
  State<AllItemsUser> createState() => _AllItemsUserState();
}

class _AllItemsUserState extends State<AllItemsUser> {
  Stream? itemsStream;
  getItems() async {
    itemsStream = await DatabaseServices().getData('items');
    setState(() {});
  }

  @override
  void initState() {
    getItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "All Items",
          style: CustomTextStyles.appBarStyle,
        ),
      ),
      body: getItemsWidget(),
    );
  }

  Widget getItemsWidget() {
    return StreamBuilder(
      stream: itemsStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return GridView.builder(
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = snapshot.data.docs[index];
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: GestureDetector(
                  onTap: () {
                    Get.to(ItemDetailUser(id: ds.id));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.skyBlueThemeColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.skyBlueThemeColor,
                          offset: const Offset(
                            2.0,
                            1.0,
                          ),
                          blurRadius: 6.0,
                          spreadRadius: 1.0,
                        ),
                        BoxShadow(
                          color: Colors.white,
                          offset: const Offset(0.0, 0.0),
                          blurRadius: 0.0,
                          spreadRadius: 0.0,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Expanded(
                            child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.network(
                            ds['image'],
                            fit: BoxFit.cover,
                          ),
                        )),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  ds['title'],
                                  style:
                                      CustomTextStyles.mediumBlackColorStyle2,
                                ),
                              ),
                              Text("\$" + ds['price']),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: AppTheme.themeColor,
            ),
          );
        }
      },
    );
  }
}
