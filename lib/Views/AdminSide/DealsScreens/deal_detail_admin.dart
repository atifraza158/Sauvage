import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dine_in/Views/Utils/Styles/theme.dart';
import 'package:flutter/material.dart';

import '../../Utils/Styles/text_styles.dart';

class DealsDetailAdmin extends StatefulWidget {
  final String id;
  const DealsDetailAdmin({
    super.key,
    required this.id,
  });

  @override
  State<DealsDetailAdmin> createState() => _DealsDetailAdminState();
}

class _DealsDetailAdminState extends State<DealsDetailAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Deal Detail",
          style: CustomTextStyles.appBarStyle,
        ),
      ),
      body: StreamBuilder(
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
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: AppTheme.themeColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            onPressed: () {},
            child: Icon(
              Icons.delete,
              color: AppTheme.whiteColor,
            ),
          ),
          SizedBox(width: 10),
          FloatingActionButton(
            backgroundColor: AppTheme.themeColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            onPressed: () {},
            child: Icon(
              Icons.edit,
              color: AppTheme.whiteColor,
            ),
          ),
        ],
      ),
    );
  }
}
