import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dine_in/Views/AdminSide/ItensScreens/add_item.dart';
import 'package:dine_in/Views/Utils/Styles/text_styles.dart';
import 'package:flutter/material.dart';

import '../../../Controllers/database_services.dart';
import '../../Utils/Styles/theme.dart';

class AllItemsAdmin extends StatefulWidget {
  const AllItemsAdmin({super.key});

  @override
  State<AllItemsAdmin> createState() => _AllItemsAdminState();
}

class _AllItemsAdminState extends State<AllItemsAdmin> {
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.themeColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return AddItem();
            },
          ));
        },
        child: Icon(
          Icons.add,
          color: AppTheme.whiteColor,
        ),
      ),
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
                      ), //BoxShadow
                      BoxShadow(
                        color: Colors.white,
                        offset: const Offset(0.0, 0.0),
                        blurRadius: 0.0,
                        spreadRadius: 0.0,
                      ), //BoxShadow
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
                            Text(
                              ds['title'],
                              style: CustomTextStyles.mediumBlackColorStyle2,
                            ),
                            Text("\$" + ds['price']),
                          ],
                        ),
                      ),
                    ],
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
