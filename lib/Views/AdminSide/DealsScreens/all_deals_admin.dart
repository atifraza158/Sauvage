import 'package:dine_in/Views/AdminSide/DealsScreens/add_deal.dart';
import 'package:flutter/material.dart';

import '../../Utils/Styles/text_styles.dart';
import '../../Utils/Styles/theme.dart';

class AllDealsAdminScreen extends StatefulWidget {
  const AllDealsAdminScreen({super.key});

  @override
  State<AllDealsAdminScreen> createState() => _AllDealsAdminScreenState();
}

class _AllDealsAdminScreenState extends State<AllDealsAdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "All Deals",
          style: CustomTextStyles.appBarStyle,
        ),
      ),
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
}
