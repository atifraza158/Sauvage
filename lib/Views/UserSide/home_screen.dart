import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dine_in/Views/UserSide/DineInScreens/all_dine_in.dart';
import 'package:dine_in/Views/UserSide/DineInScreens/dine_in_detail.dart';
import 'package:dine_in/Views/UserSide/all_deals_user.dart';
import 'package:dine_in/Views/UserSide/cart_screen.dart';
import 'package:dine_in/Views/Utils/Styles/text_styles.dart';
import 'package:dine_in/Views/Utils/Styles/theme.dart';
import 'package:dine_in/Views/static_data.dart';
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

  List imageList = [
    {"id": 1, "image_path": 'assets/images/img1.webp'},
    {"id": 2, "image_path": 'assets/images/img2.jpg'},
    {"id": 3, "image_path": 'assets/images/img3.jpg'},
    {"id": 4, "image_path": 'assets/images/img4.jpg'},
    {"id": 5, "image_path": 'assets/images/img5.jpg'},
    {"id": 6, "image_path": 'assets/images/img6.png'},
  ];

  List dineInTitlesStarters = [
    'Lahori Fried fish',
    'Aloo Tikki (3pcs)',
    'Chicken Samosa (3 pcs)',
    'Veggie Spring Roll (4 Pc)',
    'Chicken Finger & Fries',
    'Chicken Nuggets & Fries',
    'Cajun Fries',
    'French Fries',
    'Onion Rings (10 Pc)',
    'Crispy Chicken Fillet',
  ];

  List dineInPrices = [
    '15.99',
    '5.99',
    '6.99',
    '5.99',
    '10.99',
    '11.99',
    '6.99',
    '5.99',
    '7.99',
    '15.99',
  ];

  List dineInStarterImages = [
    'assets/images/Starters/Aloo Tikki.webp',
    'assets/images/Starters/Cajun Fries.jpg',
    'assets/images/Starters/Chicken Finger & Fries.webp',
    'assets/images/Starters/Chicken Nuggets & Fries.jpg',
    'assets/images/Starters/Chicken Samosa.png',
    'assets/images/Starters/Crispy Chicken Fillet.png',
    'assets/images/Starters/French Fries.jpg',
    'assets/images/Starters/Lahori Fried fish.webp',
    'assets/images/Starters/Onion Rings.jpg',
    'assets/images/Starters/Veggie Spring Rol.jpg',
  ];

  List dineInDescriptions = [
    'Lahori Fried Fish features a crunchy, golden exterior revealing succulent, flaky fish infused with vibrant and bold flavors.',
    'Hand-selected potatoes are expertly crafted into crispy potato patties, offering a genuine taste of tradition.',
    'A well-liked appetizer or snack composed of three triangular pastries stuffed with seasoned minced chicken.',
    'A plant-based starter featuring four cylinder-shaped rolls packed with a variety of vegetables.',
    'A beloved meal consisting of chicken fingers served with a side of fries.',
    'A cherished dish comprising small, breaded chicken pieces served alongside golden fries.',
    'Crispy potato sticks seasoned with a vibrant and bold Cajun spice blend, providing a spicy twist to the classic French fries.',
    'Crisp potato sticks, renowned for their delightful simplicity and crunchy texture from deep-frying.',
    'A well-loved appetizer featuring ten slices of onions, coated in a crispy batter and deep-fried.',
    'Indulge in the irresistible crunch of our Crispy Chicken Fillet, featuring golden-brown perfection on the outside and tender, flavorful chicken on the inside.',
  ];

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
                        return Stack(
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
                                    style:
                                        CustomTextStyles.mediumWhiteColorStyle,
                                  ),
                                ],
                              ),
                            ),
                          ],
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
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return AllDineInScreen();
                              },
                            ));
                          },
                          child: Text(
                            'View all',
                            style: CustomTextStyles.smallThemedColorStyle,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // SizedBox(height: 2),
                  getAllItemsWidget(),
                  // dineInWidget(),
                  Text(
                    "Categories",
                    style: CustomTextStyles.heading1,
                  ),
                  Column(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 2, top: 8, bottom: 10),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _bulidProductCategory(index: 0, name: 'Starters'),
                              _bulidProductCategory(
                                index: 1,
                                name: 'Chicken Karahi',
                              ),
                              _bulidProductCategory(
                                  index: 2, name: 'Goat Karahi'),
                              _bulidProductCategory(
                                  index: 3, name: 'CK Special'),
                              _bulidProductCategory(
                                  index: 4, name: 'Meat Curries'),
                              _bulidProductCategory(
                                  index: 5, name: 'Veggie Curries'),
                              _bulidProductCategory(
                                  index: 6, name: 'Sizzling Barbeque'),
                              _bulidProductCategory(
                                  index: 7, name: 'B.B.Q Platter'),
                              _bulidProductCategory(index: 8, name: 'Bread'),
                              _bulidProductCategory(index: 9, name: 'Drinks'),
                              _bulidProductCategory(index: 10, name: 'Rice'),
                              _bulidProductCategory(index: 11, name: 'Dessert'),
                              _bulidProductCategory(index: 12, name: 'Salad'),
                            ],
                          ),
                        ),
                      ),
                      if (isSelected == 0)
                        dineInStarterWidget(
                          StaticData.dineInStarterTitles,
                          StaticData.dineInStarterPrices,
                          StaticData.dineInStarterImages,
                          StaticData.dineInStarterDescriptions,
                        )
                      else if (isSelected == 1)
                        dineInStarterWidget(
                          StaticData.chickenKarahiTitle,
                          StaticData.chickenKarahiPrices,
                          StaticData.chickenKarahiImages,
                          StaticData.chickenKarahiDescriptions,
                        )
                      else if (isSelected == 2)
                        dineInStarterWidget(
                          StaticData.goatKarahiTitle,
                          StaticData.goatKarahiPrices,
                          StaticData.goatKarahiImages,
                          StaticData.goatKarahiDescriptions,
                        )
                      else if (isSelected == 3)
                        dineInStarterWidget(
                          StaticData.ckSpecialiTitle,
                          StaticData.ckSpecialPrices,
                          StaticData.ckSpecialImages,
                          StaticData.ckSpecialDescriptions,
                        )
                      else if (isSelected == 4)
                        dineInStarterWidget(
                          StaticData.meatCurriesTitle,
                          StaticData.meatCurriesPrices,
                          StaticData.meatCurriesImages,
                          StaticData.meatCurriesDescriptions,
                        )
                      else if (isSelected == 5)
                        dineInStarterWidget(
                          StaticData.veggieCurriesTitle,
                          StaticData.veggieCurriesPrices,
                          StaticData.veggieCurriesImages,
                          StaticData.veggieCurriesDescriptions,
                        )
                      else if (isSelected == 6)
                        dineInStarterWidget(
                          StaticData.sizzlingBarbecueTitle,
                          StaticData.sizzlingBarbecuePrices,
                          StaticData.sizzlingBarbecueImages,
                          StaticData.sizzlingBarbecueDescriptions,
                        )
                      else if (isSelected == 7)
                        dineInStarterWidget(
                          StaticData.bbqPlatterTitle,
                          StaticData.bbqPlatterPrices,
                          StaticData.bbqPlatterImages,
                          StaticData.bbqPlatterDescriptions,
                        )
                      else if (isSelected == 8)
                        dineInStarterWidget(
                          StaticData.breadTitle,
                          StaticData.breadPrices,
                          StaticData.breadImages,
                          StaticData.breadDescriptions,
                        )
                      else if (isSelected == 9)
                        dineInStarterWidget(
                          StaticData.drinksTitle,
                          StaticData.drinksPrices,
                          StaticData.drinksImages,
                          StaticData.drinksDescriptions,
                        )
                      else if (isSelected == 10)
                        dineInStarterWidget(
                          StaticData.riceTitle,
                          StaticData.ricePrices,
                          StaticData.riceImages,
                          StaticData.riceDescriptions,
                        )
                      else if (isSelected == 11)
                        dineInStarterWidget(
                          StaticData.desertTitle,
                          StaticData.desertPrices,
                          StaticData.desertImages,
                          StaticData.desertDescriptions,
                        )
                      else
                        dineInStarterWidget(
                          StaticData.saladTitle,
                          StaticData.saladPrices,
                          StaticData.saladImages,
                          StaticData.saladDescriptions,
                        )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getItemsWdget() {
    return StreamBuilder(
      stream: itemsStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: 180,
            child: ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data.docs[index];
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.skyBlueThemeColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.skyBlueThemeColor,
                          offset: const Offset(
                            2.0,
                            1.0,
                          ),
                          blurRadius: 6.0,
                          spreadRadius: 1.0,
                        ),
                        BoxShadow(
                          color: Colors.white,
                          offset: const Offset(0.0, 0.0),
                          blurRadius: 0.0,
                          spreadRadius: 0.0,
                        ),
                      ],
                    ),
                    child: Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${ds['title']}',
                            style: CustomTextStyles.commonButtonStyle,
                          ),
                          Text(
                            '\$ 15.99',
                            style: CustomTextStyles.drawerElementsStyle,
                          ),
                          Expanded(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  ds['image'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ))
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget dineInWidget2() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: 260,
      child: Row(
        children: [
          // vertical container
          Container(
            width: 120,
            height: MediaQuery.sizeOf(context).height,
            decoration: BoxDecoration(
              color: AppTheme.themeColor,
              borderRadius: BorderRadius.circular(8),
            ),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // horizonal containers..
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 120,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.lightGreen,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  Container(
                    width: 120,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.pinkAccent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 120,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.lightGreen,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  Container(
                    width: 120,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.pinkAccent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget dineInWidget() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount:
            dineInTitlesStarters.length >= 5 ? 5 : dineInTitlesStarters.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 10, bottom: 10),
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return DineInDetailScreen(
                      itemTitle: dineInTitlesStarters[index],
                      price: dineInPrices[index],
                      imagePath: dineInStarterImages[index],
                      description: dineInDescriptions[index],
                    );
                  },
                ));
              },
              child: Container(
                width: 230,
                height: 120,
                decoration: BoxDecoration(
                  color: AppTheme.blueThemeColor,
                  // color: _colorList[_random.nextInt(_colorList.length)],
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
                      Text(
                        '${dineInTitlesStarters[index]}',
                        style: CustomTextStyles.commonButtonStyle,
                      ),
                      // Text(
                      //   '\$ 15.99',
                      //   style: CustomTextStyles.drawerElementsStyle,
                      // ),
                      Expanded(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              dineInStarterImages[index],
                              fit: BoxFit.cover,
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
      ),
    );
  }

  Widget dineInStarterWidget(
    List titles,
    List prices,
    List images,
    List descriptions,
  ) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: titles.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8),
          child: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return DineInDetailScreen(
                    itemTitle: titles[index],
                    price: prices[index],
                    imagePath: images[index],
                    description: descriptions[index],
                  );
                },
              ));
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
                    Text(
                      '${titles[index]}',
                      style: CustomTextStyles.commonButtonStyle,
                    ),
                    Text(
                      '\$ ${prices[index]}',
                      style: CustomTextStyles.drawerElementsStyle,
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(images[index]),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  _bulidProductCategory({required int index, required String name}) =>
      GestureDetector(
        onTap: () => setState(() => isSelected = index),
        child: Container(
          margin: EdgeInsets.only(top: 5, right: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color:
                isSelected == index ? AppTheme.themeColor : Colors.transparent,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
                color: isSelected == index
                    ? AppTheme.themeColor
                    : AppTheme.blackColor),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Text(
              name,
              style: TextStyle(
                  color:
                      isSelected == index ? AppTheme.whiteColor : Colors.black,
                  fontFamily: 'poppins'),
            ),
          ),
        ),
      );

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
                    onTap: () {},
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
}
