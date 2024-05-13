import 'package:dine_in/Views/UserSide/order_placed.dart';
import 'package:dine_in/Views/Utils/Components/login_button.dart';
import 'package:dine_in/Views/Utils/Styles/text_styles.dart';
import 'package:dine_in/Views/Utils/Styles/theme.dart';
import 'package:flutter/material.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  TextEditingController dateTimeController = TextEditingController();
  int isSelected = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.shopping_cart_rounded,
                        color: AppTheme.themeColor,
                        size: 70,
                      ),
                      Text(
                        "Summary",
                        style: CustomTextStyles.mediumThemeColorColorStyle,
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Column(
                  children: [
                    itemsTiles('Chicken Karahhi', '24.99'),
                    itemsTiles('Rose Falooda Ice Crean', '5.99'),
                    itemsTiles('Mango, Sweet, Salty Lassi', '5.99'),
                  ],
                ),
                SizedBox(height: 30),
                itemsTiles('Total', '36.97'),
                SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Card Holder Name ",
                      style: CustomTextStyles.mediumBlackColorStyle2,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        focusColor: AppTheme.themeColor,
                        hoverColor: AppTheme.themeColor,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Card Number: ",
                      style: CustomTextStyles.mediumBlackColorStyle2,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.credit_card,
                          color: AppTheme.themeColor,
                          size: 40,
                        ),
                        focusColor: AppTheme.themeColor,
                        hoverColor: AppTheme.themeColor,
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
                              TextFormField(
                                controller: dateTimeController,
                                decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _selectDate();
                                    });
                                  },
                                  icon: Icon(
                                    Icons.timer,
                                    color: AppTheme.themeColor,
                                  ),
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
                              TextFormField(),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: CommonButton(
          child: Text(
            "CheckOut",
            style: CustomTextStyles.commonButtonStyle,
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return OrderPlacedSuccessfully();
              },
            ));
          },
        ),
      ),
    );
  }

  paymentButton({required int index, required String imagePath}) =>
      GestureDetector(
        onTap: () => setState(() => isSelected = index),
        child: Container(
          margin: EdgeInsets.only(top: 5, right: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color:
                isSelected == index ? AppTheme.themeColor : Colors.transparent,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(),
          ),
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Expanded(child: Image.asset('${imagePath}'))),
        ),
      );

  Widget itemsTiles(String name, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Container(
        height: 70,
        width: MediaQuery.sizeOf(context).width,
        decoration: BoxDecoration(
            color: AppTheme.skyBlueThemeColor,
            borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${name}', style: CustomTextStyles.mediumBlackColorStyle2),
              Text(
                '\$${price}',
                style: CustomTextStyles.mediumGreyColorStyle,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget paymentEntries() {
    return Row(
      children: [
        TextFormField(
          decoration: InputDecoration(label: Text("Card holder name")),
        ),
      ],
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
}
