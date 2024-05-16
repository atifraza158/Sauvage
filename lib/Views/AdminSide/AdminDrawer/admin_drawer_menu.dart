import 'package:dine_in/Views/AdminSide/DealsScreens/all_deals_admin.dart';
import 'package:dine_in/Views/AdminSide/ItensScreens/all_items_admin.dart';
import 'package:dine_in/Views/Utils/Styles/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../Controllers/database_services.dart';
import '../../AuthScreens/login_screen.dart';
import '../../Utils/Styles/text_styles.dart';

class AdminDrawerMenu extends StatefulWidget {
  const AdminDrawerMenu({super.key});

  @override
  State<AdminDrawerMenu> createState() => _AdminDrawerMenuState();
}

class _AdminDrawerMenuState extends State<AdminDrawerMenu> {
  User? currentUser;
  DatabaseServices controller = Get.put(DatabaseServices());

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
                            currentUser == null ? "username" : "username",
                            style: CustomTextStyles.drawerElementsStyle,
                          ),
                          Text(
                            currentUser == null
                                ? 'example@gmail.com'
                                : "${currentUser!.email}",
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
                        return AllItemsAdmin();
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
                          "All Items Added",
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
                        return AllDealsAdminScreen();
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
                          "All Deals",
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
                      controller.logOut();
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
