import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dine_in/Views/UserSide/DealsScreensUser/deal_detail_user.dart';
import 'package:dine_in/Views/UserSide/ItemsScreens/all_items_user.dart';
import 'package:dine_in/Views/UserSide/ItemsScreens/item_detail_User.dart';
import 'package:dine_in/Views/UserSide/DealsScreensUser/all_deals_user.dart';
import 'package:dine_in/Views/UserSide/cart_screen.dart';
import 'package:dine_in/Views/Utils/Styles/text_styles.dart';
import 'package:dine_in/Views/Utils/Styles/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';

import '../../Controllers/database_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CarouselController carouselController = CarouselController();
  int currentIndex = 0;
  int isSelected = 0;

  String selectedCategoryId = '';

  final PageController _pageController = PageController();
  int currentPage = 0;
  int totalPages = 0;
  Timer? timer;

  Stream? itemsStream;
  getItems() async {
    itemsStream = await DatabaseServices().getData('items');
    setState(() {});
  }

  Stream? dealsStream;
  getDeals() async {
    dealsStream = await DatabaseServices().getData('deals');
    setState(() {});
  }

  @override
  void dispose() {
    timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getItems();
    startTimer();
    getDeals();
    super.initState();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (currentPage < totalPages) {
        _pageController.animateToPage(
          currentPage++,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      } else {
        currentPage = 0;
        _pageController.jumpToPage(currentPage);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Sauvage",
          style: CustomTextStyles.appBarStyle,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return CartScreen();
                },
              ));
            },
            icon: Icon(
              Icons.shopping_cart,
            ),
          ),
        ],
        leading: IconButton(
          onPressed: () {
            ZoomDrawer.of(context)!.toggle();
          },
          icon: Icon(
            Icons.menu,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Deals",
                    style: CustomTextStyles.heading1,
                  ),
                  TextButton(
                    onPressed: () {
                      Get.to(() => AllDealsUser());
                    },
                    child: Text(
                      'View All',
                      style: CustomTextStyles.smallThemedColorStyle,
                    ),
                  ),
                ],
              ),
            ),
            StreamBuilder(
              stream: dealsStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  totalPages = snapshot.data.docs.length;
                  return SizedBox(
                    height: 150,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot ds = snapshot.data.docs[index];
                        return GestureDetector(
                          onTap: () {
                            Get.to(() => DealDetailUser(id: ds.id));
                          },
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(),
                                width: MediaQuery.sizeOf(context).width,
                                child: Image.network(
                                  ds['image'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 150,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.topRight,
                                    colors: [
                                      AppTheme.blackColor.withOpacity(0.5),
                                      AppTheme.whiteColor.withOpacity(0.5),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0,
                                  vertical: 10,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ds['title'],
                                      style: CustomTextStyles.appBarWhiteStyle,
                                    ),
                                    Text(
                                      '\$${ds['price']}',
                                      style: CustomTextStyles
                                          .mediumWhiteColorStyle,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.themeColor,
                    ),
                  );
                }
              },
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Today\'s Menu",
                          style: CustomTextStyles.heading1,
                        ),
                        TextButton(
                          onPressed: () {
                            Get.to(() => AllItemsUser());
                          },
                          child: Text(
                            'View all',
                            style: CustomTextStyles.smallThemedColorStyle,
                          ),
                        ),
                      ],
                    ),
                  ),
                  getAllItemsWidget(),
                  Text(
                    "Categories",
                    style: CustomTextStyles.heading1,
                  ),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('categories')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<QueryDocumentSnapshot> categories =
                            snapshot.data!.docs;
                        if (selectedCategoryId.isEmpty) {
                          selectedCategoryId = categories.first.id;
                        }
                        return Column(
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: categories.map((category) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedCategoryId = category.id;
                                      });
                                      FirebaseFirestore.instance
                                          .collection('items')
                                          .where('category_id',
                                              isEqualTo: category.id)
                                          .get()
                                          .then((querySnapshot) {
                                        List<QueryDocumentSnapshot> items =
                                            querySnapshot.docs;
                                        return gridView(context, items);
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: category.id == selectedCategoryId
                                            ? AppTheme.themeColor
                                            : AppTheme.whiteColor,
                                        borderRadius: BorderRadius.circular(28),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5.0),
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  category['image']),
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              category['title'],
                                              style: category.id ==
                                                      selectedCategoryId
                                                  ? CustomTextStyles
                                                      .smallWhiteColorStyle
                                                  : CustomTextStyles
                                                      .smallBlackColorStyle,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            // Display the items in a GridView
                            StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('items')
                                  .where('category_id',
                                      isEqualTo: selectedCategoryId)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  List<QueryDocumentSnapshot> items =
                                      snapshot.data!.docs;
                                  return gridView(context, items);
                                } else {
                                  return Center(
                                      child: CircularProgressIndicator());
                                }
                              },
                            ),
                          ],
                        );
                      } else {
                        return Center(
                            child: CircularProgressIndicator(
                          color: AppTheme.themeColor,
                        ));
                      }
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getAllItemsWidget() {
    return SizedBox(
      height: 170,
      child: StreamBuilder(
        stream: itemsStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data.docs.length <= 5
                  ? snapshot.data.docs.length
                  : 5,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data.docs[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 10, bottom: 10),
                  child: GestureDetector(
                    onTap: () {
                      Get.to(() => ItemDetailUser(id: ds.id));
                    },
                    child: Container(
                      width: 230,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppTheme.blueThemeColor,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            blurRadius: 4,
                            offset: Offset(4, 8),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${ds['title']}',
                                      style: CustomTextStyles.commonButtonStyle,
                                    ),
                                  ),
                                  Text(
                                    '\$ 15.99',
                                    style: CustomTextStyles.drawerElementsStyle,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      ds['image'],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ))
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(
                color: AppTheme.themeColor,
              ),
            );
          }
        },
      ),
    );
  }

  // GridView widget
  Widget gridView(BuildContext context, List<QueryDocumentSnapshot> items) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: GestureDetector(
            onTap: () {
              Get.to(ItemDetailUser(id: items[index]['id']));
            },
            child: Container(
              width: 200,
              height: 120,
              decoration: BoxDecoration(
                color: AppTheme.themeColor,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.greyColor.withOpacity(0.5),
                    blurRadius: 4,
                    offset: Offset(4, 8),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '${items[index]['title']}',
                            style: CustomTextStyles.commonButtonStyle,
                          ),
                        ),
                        Text(
                          '\$ ${items[index]['price']}',
                          style: CustomTextStyles.drawerElementsStyle,
                        ),
                      ],
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            items[index]['image'],
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
        // return GridTile(
        //   child: Card(
        //     child: Column(
        //       children: [
        //         Expanded(
        //           child: Image.network(
        //             items[index]['image'],
        //             fit: BoxFit.cover,
        //           ),
        //         ),
        //         Text(items[index]['title']),
        //         Text(items[index]['price'].toString()),
        //       ],
        //     ),
        //   ),
        // );
      },
    );
  }
}
