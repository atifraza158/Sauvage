import 'package:dine_in/Views/UserSide/DrawerScreens/user_drawer_menu.dart';
import 'package:dine_in/Views/Utils/Styles/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

import '../main_screen.dart';

class UserDrawerScreen extends StatefulWidget {
  const UserDrawerScreen({super.key});

  @override
  State<UserDrawerScreen> createState() => _UserDrawerScreenState();
}

class _UserDrawerScreenState extends State<UserDrawerScreen> {
  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      menuScreen: UserDrawerMenu(),
      mainScreen: MainScreenUser(),
      angle: 0,
      duration: Duration(milliseconds: 200),
      menuBackgroundColor: AppTheme.themeColor,
    );
  }
}
