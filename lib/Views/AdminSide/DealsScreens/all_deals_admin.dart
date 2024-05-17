import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dine_in/Views/AdminSide/DealsScreens/add_deal.dart';
import 'package:flutter/material.dart';

import '../../../Controllers/database_services.dart';
import '../../Utils/Styles/text_styles.dart';
import '../../Utils/Styles/theme.dart';

class AllDealsAdminScreen extends StatefulWidget {
  const AllDealsAdminScreen({super.key});

  @override
  State<AllDealsAdminScreen> createState() => _AllDealsAdminScreenState();
}

class _AllDealsAdminScreenState extends State<AllDealsAdminScreen> {
  Stream? dealsStream;
  getItems() async {
    dealsStream = await DatabaseServices().getData('deals');
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
          "All Deals",
          style: CustomTextStyles.appBarStyle,
        ),
      ),
      body: getAllDealsWidget(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.themeColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return AddDeal();
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

  Widget getAllDealsWidget() {
    return StreamBuilder(
      stream: dealsStream,
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
                                style: CustomTextStyles.mediumBlackColorStyle2,
                              ),
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
