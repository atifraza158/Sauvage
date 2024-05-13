import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dine_in/Views/AdminSide/CategoriesScreens/all_categories.dart';
import 'package:dine_in/Views/AdminSide/DealsScreens/all_deals_admin.dart';
import 'package:dine_in/Views/AdminSide/ItensScreens/all_items_admin.dart';
import 'package:dine_in/Views/Utils/Styles/text_styles.dart';
import 'package:dine_in/Views/Utils/Styles/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

import '../../Controllers/database_services.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  Stream? categoryStream;
  Stream? itemsStream;
  getCategories() async {
    categoryStream = await DatabaseServices().getData('categories');
    setState(() {});
  }

  getItems() async {
    itemsStream = await DatabaseServices().getData('items');
    setState(() {});
  }

  @override
  void initState() {
    getCategories();
    getItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.themeColor,
        title: Text(
          "Admin Panel",
          style: CustomTextStyles.appBarWhiteStyle,
        ),
        leading: IconButton(
          onPressed: () {
            ZoomDrawer.of(context)!.toggle();
          },
          icon: Icon(
            Icons.menu,
            color: AppTheme.whiteColor,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'All Categories',
                    style: CustomTextStyles.mediumBlackColorStyle2,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return AllCategoriesAdminScreen();
                        },
                      ));
                    },
                    child: Text(
                      'View all',
                      style: CustomTextStyles.mediumThemeColorColorStyle,
                    ),
                  ),
                ],
              ),
              getAllCatogeriesWidget(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'All items',
                    style: CustomTextStyles.mediumBlackColorStyle2,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return AllItemsAdmin();
                        },
                      ));
                    },
                    child: Text(
                      'View all',
                      style: CustomTextStyles.mediumThemeColorColorStyle,
                    ),
                  ),
                ],
              ),
              getAllItemsWidget(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'All Deals',
                    style: CustomTextStyles.mediumBlackColorStyle2,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return AllDealsAdminScreen();
                        },
                      ));
                    },
                    child: Text(
                      'View all',
                      style: CustomTextStyles.mediumThemeColorColorStyle,
                    ),
                  ),
                ],
              ),
              getAllCatogeriesWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget getAllItemsWidget() {
    return StreamBuilder(
      stream: itemsStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data.docs[index];
                return Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Container(
                    child: Column(
                      children: [
                        Expanded(
                            child: Image.network(
                          ds['image'],
                          fit: BoxFit.cover,
                        )),
                        Text(ds['title'].toString())
                      ],
                    ),
                  ),
                );
              },
            ),
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

  Widget getAllCatogeriesWidget() {
    return StreamBuilder(
      stream: categoryStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data.docs[index];
                return Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Container(
                    child: Column(
                      children: [
                        Expanded(
                            child: Image.network(
                          ds['image'],
                          fit: BoxFit.cover,
                        )),
                        Text(ds['title'].toString())
                      ],
                    ),
                  ),
                );
              },
            ),
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
