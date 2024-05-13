import 'package:dine_in/Views/UserSide/checkout.dart';
import 'package:dine_in/Views/Utils/Components/login_button.dart';
import 'package:dine_in/Views/Utils/Styles/text_styles.dart';
import 'package:dine_in/Views/Utils/Styles/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CartItem> _cartItems = [
    CartItem(name: 'Chicken Karahi (Bone-In)', price: 24.99, quantity: 1),
    CartItem(name: 'Rose Falooda Ice Cream', price: 5.99, quantity: 1),
    CartItem(name: 'Mango, Sweet, Salty Lassi', price: 5.99, quantity: 1),
  ];
  String totalPrice = '36.97';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Cart",
          style: CustomTextStyles.appBarStyle,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _cartItems.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.skyBlueThemeColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        title: Text(
                          _cartItems[index].name,
                          style: CustomTextStyles.mediumBlackColorStyle2,
                        ),
                        subtitle: Text(
                          'Price: \$${_cartItems[index].price.toStringAsFixed(2)}',
                          style: CustomTextStyles.smallGreyColorStyle,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppTheme.whiteColor,
                              ),
                              child: IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: () {
                                  setState(() {
                                    if (_cartItems[index].quantity > 1) {
                                      _cartItems[index].quantity--;
                                    }
                                  });
                                },
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              _cartItems[index].quantity.toString(),
                              style: CustomTextStyles.mediumBlackColorStyle2,
                            ),
                            SizedBox(width: 8),
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppTheme.whiteColor,
                              ),
                              child: IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () {
                                  setState(() {
                                    _cartItems[index].quantity++;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        onTap: () {},
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Selected items(3)',
                  style: CustomTextStyles.mediumBlackColorStyle2,
                ),
                Text(
                  "Total: \$${totalPrice}",
                  style: CustomTextStyles.mediumGreyColorStyle,
                ),
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: CommonButton(
            child: Text(
              'CheckOut',
              style: CustomTextStyles.commonButtonStyle,
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return CheckOutScreen();
                },
              ));
            }),
      ),
    );
  }
}

class CartItem {
  String name;
  double price;
  int quantity;

  CartItem({required this.name, required this.price, required this.quantity});
}
