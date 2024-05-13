import 'package:dine_in/Controllers/firebase_services.dart';
import 'package:dine_in/Views/AuthScreens/login_screen.dart';
import 'package:dine_in/Views/UserSide/CategoringScreens/catering_rates.dart';
import 'package:dine_in/Views/UserSide/DineInScreens/all_dine_in.dart';
import 'package:dine_in/Views/UserSide/take_out.dart';
import 'package:dine_in/Views/Utils/Styles/text_styles.dart';
import 'package:dine_in/Views/Utils/Styles/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UserDrawerMenu extends StatefulWidget {
  const UserDrawerMenu({super.key});

  @override
  State<UserDrawerMenu> createState() => _UserDrawerMenuState();
}

class _UserDrawerMenuState extends State<UserDrawerMenu> {
  User? currentUser;

  checkUser() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.themeColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 80),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(''),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Wrap(
                        direction: Axis.vertical,
                        children: [
                          Text(
                            "username",
                            style: CustomTextStyles.drawerElementsStyle,
                          ),
                          Text(
                            "${currentUser!.email}",
                            style: CustomTextStyles.drawerElementsStyle,
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
            // SizedBox(height: 50),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    ZoomDrawer.of(context)!.toggle();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.house,
                          color: AppTheme.whiteColor,
                          size: 20,
                        ),
                        SizedBox(width: 12),
                        Text(
                          "Home",
                          style: CustomTextStyles.drawerElementsStyle,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Divider(),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return AllDineInScreen();
                      },
                    ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      children: [
                        Icon(
                          Icons.restaurant,
                          color: AppTheme.whiteColor,
                          size: 20,
                        ),
                        SizedBox(width: 12),
                        Text(
                          "Dine In",
                          style: CustomTextStyles.drawerElementsStyle,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Divider(),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return CateringScreen();
                      },
                    ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      children: [
                        Icon(
                          Icons.restaurant_menu,
                          color: AppTheme.whiteColor,
                          size: 20,
                        ),
                        SizedBox(width: 12),
                        Text(
                          "Catering",
                          style: CustomTextStyles.drawerElementsStyle,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Divider(),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return AllTakeOuts();
                      },
                    ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      children: [
                        Icon(
                          Icons.takeout_dining,
                          color: AppTheme.whiteColor,
                          size: 20,
                        ),
                        SizedBox(width: 12),
                        Text(
                          "Take Out",
                          style: CustomTextStyles.drawerElementsStyle,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Divider(),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.addressBook,
                          color: AppTheme.whiteColor,
                          size: 20,
                        ),
                        SizedBox(width: 12),
                        Text(
                          "Contact Us",
                          style: CustomTextStyles.drawerElementsStyle,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Divider(),
                ),
              ],
            ),
            currentUser == null
                ? GestureDetector(
                    onTap: () {
                      print(currentUser);
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return LoginScreen();
                        },
                      ));
                    },
                    child: Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.arrowRightToBracket,
                          color: AppTheme.whiteColor,
                          size: 20,
                        ),
                        SizedBox(width: 15),
                        Text(
                          'Login',
                          style: CustomTextStyles.drawerElementsStyle,
                        ),
                      ],
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      Fluttertoast.showToast(msg: 'Logout Successfully');
                      FirebaseServices().logout(context);
                    },
                    child: Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.arrowRightToBracket,
                          color: AppTheme.whiteColor,
                          size: 20,
                        ),
                        SizedBox(width: 15),
                        Text(
                          'Logout',
                          style: CustomTextStyles.drawerElementsStyle,
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
