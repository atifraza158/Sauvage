import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dine_in/Views/UserSide/DealsScreensUser/deal_detail_user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/database_services.dart';
import '../../Utils/Styles/text_styles.dart';
import '../../Utils/Styles/theme.dart';

class AllDealsUser extends StatefulWidget {
  const AllDealsUser({super.key});

  @override
  State<AllDealsUser> createState() => _AllDealsUserState();
}

class _AllDealsUserState extends State<AllDealsUser> {
  Stream? dealsStream;
  getDeals() async {
    dealsStream = await DatabaseServices().getData('deals');
    setState(() {});
  }

  @override
  void initState() {
    getDeals();
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
                padding: const EdgeInsets.all(8),
                child: GestureDetector(
                  onTap: () {
                    Get.to(() => DealDetailUser(id: ds.id));
                  },
                  child: Container(
                    width: 200,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppTheme.themeColor,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.greyColor.withOpacity(0.5),
                          blurRadius: 4,
                          offset: Offset(4, 8),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${ds['title']}',
                            style: CustomTextStyles.commonButtonStyle,
                          ),
                          Text(
                            '\$ ${ds['price']}',
                            style: CustomTextStyles.drawerElementsStyle,
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(ds['image']),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
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
