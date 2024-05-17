import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dine_in/Views/Utils/Styles/text_styles.dart';
import 'package:flutter/material.dart';

class ItemDetailAdmin extends StatefulWidget {
  final String id;
  const ItemDetailAdmin({
    super.key,
    required this.id,
  });

  @override
  State<ItemDetailAdmin> createState() => _ItemDetailAdminState();
}

class _ItemDetailAdminState extends State<ItemDetailAdmin> {
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
                        Text(
                          'Price: \$${ds['price']}',
                          style: CustomTextStyles.mediumBlackColorStyle2,
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
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
