import 'package:dine_in/Views/UserSide/ItemsScreens/all_items_user.dart';
import 'package:dine_in/Views/UserSide/home_screen.dart';
import 'package:dine_in/Views/Utils/Styles/theme.dart';
import 'package:flutter/material.dart';

import '../user_profile.dart';

class MainScreenUser extends StatefulWidget {
  const MainScreenUser({super.key});

  @override
  State<MainScreenUser> createState() => _MainScreenUserState();
}

class _MainScreenUserState extends State<MainScreenUser> {
  int selectedPage = 0;
  selectCurrentPage(int index) {
    setState(() {
      selectedPage = index;
    });
  }

  List<Widget> screens = [
    HomeScreen(),
    AllItemsUser(),
    UserProfile(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[selectedPage],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: selectCurrentPage,
        selectedIndex: selectedPage,
        indicatorColor: AppTheme.themeColor,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        destinations: [
          NavigationDestination(
              icon: Icon(
                Icons.home,
                color: selectedPage == 0 ? Colors.white : Colors.black,
              ),
              label: "Home"),
          NavigationDestination(
              icon: Icon(
                Icons.food_bank,
                color: selectedPage == 1 ? Colors.white : Colors.black,
              ),
              label: "Deals"),
          // NavigationDestination(
          //     icon: Icon(
          //       Icons.shopping_cart,
          //       color: selectedPage == 2 ? Colors.white : Colors.black,
          //     ),
          //     label: "Cart"),
          NavigationDestination(
              icon: Icon(
                Icons.person,
                color: selectedPage == 3 ? Colors.white : Colors.black,
              ),
              label: "Account"),
        ],
      ),
    );
  }
}
