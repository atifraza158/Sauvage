import 'package:dine_in/Views/UserSide/cart_screen.dart';
import 'package:dine_in/Views/Utils/Components/login_button.dart';
import 'package:dine_in/Views/Utils/Styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DineInDetailScreen extends StatefulWidget {
  final String itemTitle;
  final String imagePath;
  final String price;
  final String description;

  const DineInDetailScreen({
    super.key,
    required this.itemTitle,
    required this.price,
    required this.imagePath,
    required this.description,
  });

  @override
  State<DineInDetailScreen> createState() => _DineInDetailScreenState();
}

class _DineInDetailScreenState extends State<DineInDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  height: MediaQuery.sizeOf(context).height / 2.3,
                  child: Image.asset(
                    width: MediaQuery.sizeOf(context).width,
                    widget.imagePath,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 25, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '${widget.itemTitle}',
                    style: CustomTextStyles.appBarStyle,
                  ),
                  SizedBox(height: 30),
                  Row(
                    children: [
                      Text(
                        'Full Plate: ',
                        style: CustomTextStyles.mediumBlackColorStyle2,
                      ),
                      Text(
                        '\$ ${widget.price}',
                        style: CustomTextStyles.mediumGreyColorStyle,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Half Plate: ',
                        style: CustomTextStyles.mediumBlackColorStyle2,
                      ),
                      Text(
                        '\$ ${widget.price}',
                        style: CustomTextStyles.mediumGreyColorStyle,
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(
                    "${widget.description}",
                    style: CustomTextStyles.smallGreyColorStyle,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: CommonButton(
            child: Text(
              "Add to Cart",
              style: CustomTextStyles.commonButtonStyle,
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return CartScreen();
                },
              ));
            }),
      ),
    );
  }
}
