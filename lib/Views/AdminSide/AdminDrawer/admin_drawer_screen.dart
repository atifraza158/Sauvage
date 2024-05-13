import 'package:dine_in/Views/AdminSide/AdminDrawer/admin_drawer_menu.dart';
import 'package:dine_in/Views/AdminSide/admin_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

import '../../Utils/Styles/theme.dart';

class AdminDrawerScreen extends StatefulWidget {
  const AdminDrawerScreen({super.key});

  @override
  State<AdminDrawerScreen> createState() => _AdminDrawerScreenState();
}

class _AdminDrawerScreenState extends State<AdminDrawerScreen> {
  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      menuScreen: AdminDrawerMenu(),
      mainScreen: AdminPanel(),
      angle: 0,
      duration: Duration(milliseconds: 200),
      menuBackgroundColor: AppTheme.themeColor,
    );
  }
}
