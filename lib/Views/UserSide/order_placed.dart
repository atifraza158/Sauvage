import 'package:dine_in/Views/Utils/Styles/text_styles.dart';
import 'package:dine_in/Views/Utils/Styles/theme.dart';
import 'package:flutter/material.dart';

class OrderPlacedSuccessfully extends StatefulWidget {
  const OrderPlacedSuccessfully({super.key});

  @override
  State<OrderPlacedSuccessfully> createState() =>
      _OrderPlacedSuccessfullyState();
}

class _OrderPlacedSuccessfullyState extends State<OrderPlacedSuccessfully> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: -50,
            right: -10,
            child: Container(
              height: 300,
              width: 250,
              decoration: BoxDecoration(
                color: AppTheme.themeColor,
                borderRadius:
                    BorderRadius.only(bottomLeft: Radius.circular(250)),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 80,
                  width: 100,
                  decoration: BoxDecoration(
                    color: AppTheme.themeColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.done,
                    color: AppTheme.whiteColor,
                    size: 50,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  "Order Placed Successfully",
                  style: CustomTextStyles.appBarStyle,
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.themeColor,
                  ),
                  onPressed: () {
                    
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      "Explore more",
                      style: CustomTextStyles.mediumWhiteColorStyle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
