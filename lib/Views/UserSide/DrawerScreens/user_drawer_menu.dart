import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dine_in/Controllers/database_services.dart';
import 'package:dine_in/Views/AuthScreens/login_screen.dart';
import 'package:dine_in/Views/UserSide/ItemsScreens/all_items_user.dart';
import 'package:dine_in/Views/UserSide/DineInScreens/all_dine_in.dart';
import 'package:dine_in/Views/UserSide/all_deals_user.dart';
import 'package:dine_in/Views/Utils/Styles/text_styles.dart';
import 'package:dine_in/Views/Utils/Styles/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class UserDrawerMenu extends StatefulWidget {
  const UserDrawerMenu({super.key});

  @override
  State<UserDrawerMenu> createState() => _UserDrawerMenuState();
}

class _UserDrawerMenuState extends State<UserDrawerMenu> {
  User? currentUser;
  DatabaseServices controller = Get.put(DatabaseServices());
  Stream? userStream;
  getUser() async {
    userStream = await DatabaseServices().getData('auth');
    setState(() {});
  }

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
    getUser();
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
                  child: Icon(Icons.person),
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
                          StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('auth')
                                .doc(currentUser!.uid)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                DocumentSnapshot<Map<String, dynamic>>?
                                    userDoc = snapshot.data;
                                String username = userDoc!['name'];
                                return Text(
                                  username,
                                  style: CustomTextStyles.drawerElementsStyle,
                                );
                              } else {
                                return Text(
                                  "username",
                                  style: CustomTextStyles.drawerElementsStyle,
                                );
                              }
                            },
                          ),
                          Text(
                            currentUser != null
                                ? "${currentUser!.email}"
                                : 'example@gmail.com',
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
                        return AllItemsUser();
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
                    Get.to(() => AllDealsUser());
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
