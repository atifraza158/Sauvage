import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dine_in/Views/UserSide/order_placed.dart';
import 'package:dine_in/Views/Utils/Components/common_field.dart';
import 'package:dine_in/Views/Utils/Components/login_button.dart';
import 'package:dine_in/Views/Utils/Styles/text_styles.dart';
import 'package:dine_in/Views/Utils/Styles/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class CheckOutScreen extends StatefulWidget {
  final List items;
  final List deals;
  const CheckOutScreen({
    super.key,
    required this.items,
    required this.deals,
  });

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  TextEditingController dateTimeController = TextEditingController();
  final cardName = TextEditingController();
  final cardNoController = TextEditingController();
  final cvvController = TextEditingController();

  User? currentUser;
  checkUser() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        currentUser = user;
      });
    });
  }

  @override
  void initState() {
    checkUser();
    super.initState();
  }

  final key = GlobalKey<FormState>();
  int isSelected = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Icon(
                Icons.shopping_cart_rounded,
                color: AppTheme.themeColor,
                size: 70,
              ),
              OnlinePaymentTab()
            ],
          ),
        ),
      ),
    );
  }

  DateTime? _selectedDate;

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        dateTimeController.text = _selectedDate
            .toString()
            .split(' ')[0]; // Extracting only the date part
      });
    }
  }

  Widget OnlinePaymentTab() {
    return Form(
      key: key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Card Holder Name ",
            style: CustomTextStyles.mediumBlackColorStyle2,
          ),
          CommonTextField(
            controller: cardName,
            validate: (val) {},
            obsecureText: false,
            hintText: 'John Doe',
          ),
          SizedBox(height: 20),
          Text(
            "Card Number: ",
            style: CustomTextStyles.mediumBlackColorStyle2,
          ),
          CommonTextField(
            controller: cardNoController,
            validate: (val) {},
            obsecureText: false,
            hintText: '0000 0000 0000 0000',
            icon: Icon(
              Icons.credit_card,
              color: AppTheme.themeColor,
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Exp. Date",
                      style: CustomTextStyles.mediumBlackColorStyle2,
                    ),
                    CommonTextField(
                      controller: dateTimeController,
                      validate: (val) {},
                      obsecureText: false,
                      icon: IconButton(
                          onPressed: () {
                            _selectDate();
                          },
                          icon: Icon(
                            Icons.access_alarm,
                            color: AppTheme.themeColor,
                          )),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "CVV",
                      style: CustomTextStyles.mediumBlackColorStyle2,
                    ),
                    CommonTextField(
                      controller: cvvController,
                      validate: (val) {},
                      obsecureText: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          CommonButton(
            child: Text(
              "Buy Now",
              style: CustomTextStyles.commonButtonStyle,
            ),
            onPressed: () {
              if (key.currentState!.validate()) {
                saveOrderDetails();
              }
            },
          )
        ],
      ),
    );
  }

  Future<void> saveOrderDetails() async {
    try {
      await FirebaseFirestore.instance.collection('orders').add({
        'userId': currentUser!.uid,
        'items': widget.items,
        'deals': widget.deals,
        'cardHolderName': cardName.text,
        'cardNumber': cardNoController.text,
        'expDate': dateTimeController.text,
        'cvv': cvvController.text,
        'orderDate': DateTime.now(),
      });
      await FirebaseFirestore.instance
          .collection('carts')
          .doc(currentUser!.uid)
          .update({'items': [], 'deals': []});
      Get.to(() => OrderPlacedSuccessfully());
    } catch (e) {
      print(e.toString());
    }
  }
}
