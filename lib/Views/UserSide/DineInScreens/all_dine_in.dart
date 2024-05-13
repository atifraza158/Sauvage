import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dine_in/Views/Utils/Styles/text_styles.dart';
import 'package:dine_in/Views/static_data.dart';
import 'package:flutter/material.dart';

import '../../../Controllers/database_services.dart';
import '../../Utils/Styles/theme.dart';
import 'dine_in_detail.dart';

class AllDineInScreen extends StatefulWidget {
  const AllDineInScreen({super.key});

  @override
  State<AllDineInScreen> createState() => _AllDineInScreenState();
}

class _AllDineInScreenState extends State<AllDineInScreen> {
  int isSelected = 0;

  List allCategories = [
    'Starters',
    'Chicken Karahi',
    'Goat Karahi',
    'CK Special',
    'Meat Curries',
    'Veggie Curries',
    'Sizzling Barbeque',
    'B.B.Q Platter',
    'Bread',
    'Drinks',
    'Rice',
    'Dessert',
    'Salad',
  ];

  Stream? itemsStream;
  getItems() async {
    itemsStream = await DatabaseServices().getData('items');
    setState(() {});
  }

  @override
  void initState() {
    getItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.whiteColor,
        title: Text(
          "All Items",
          style: CustomTextStyles.appBarStyle,
        ),
      ),
      body: getItemsWidget(),
      // body: Column(
      //   children: [
      //     Padding(
      //       padding: const EdgeInsets.only(left: 10, top: 8, bottom: 10),
      //       child: SingleChildScrollView(
      //         scrollDirection: Axis.horizontal,
      //         child: Row(
      //           children: [
      //             _bulidProductCategory(index: 0, name: 'Starters'),
      //             _bulidProductCategory(index: 1, name: 'Chicken Karahi'),
      //             _bulidProductCategory(index: 2, name: 'Goat Karahi'),
      //             _bulidProductCategory(index: 3, name: 'CK Special'),
      //             _bulidProductCategory(index: 4, name: 'Meat Curries'),
      //             _bulidProductCategory(index: 5, name: 'Veggie Curries'),
      //             _bulidProductCategory(index: 6, name: 'Sizzling Barbeque'),
      //             _bulidProductCategory(index: 7, name: 'B.B.Q Platter'),
      //             _bulidProductCategory(index: 8, name: 'Bread'),
      //             _bulidProductCategory(index: 9, name: 'Drinks'),
      //             _bulidProductCategory(index: 10, name: 'Rice'),
      //             _bulidProductCategory(index: 11, name: 'Dessert'),
      //             _bulidProductCategory(index: 12, name: 'Salad'),
      //           ],
      //         ),
      //       ),
      //     ),
      //     if (isSelected == 0)
      //       Expanded(
      //           child: dineInStarterWidget(
      //               StaticData.dineInStarterTitles,
      //               StaticData.dineInStarterPrices,
      //               StaticData.dineInStarterImages,
      //               StaticData.dineInStarterDescriptions))
      //     else if (isSelected == 1)
      //       Expanded(
      //           child: dineInStarterWidget(
      //               StaticData.chickenKarahiTitle,
      //               StaticData.chickenKarahiPrices,
      //               StaticData.chickenKarahiImages,
      //               StaticData.chickenKarahiDescriptions))
      //     else if (isSelected == 2)
      //       Expanded(
      //           child: dineInStarterWidget(
      //         StaticData.goatKarahiTitle,
      //         StaticData.goatKarahiPrices,
      //         StaticData.goatKarahiImages,
      //         StaticData.goatKarahiDescriptions,
      //       ))
      //     else if (isSelected == 3)
      //       Expanded(
      //           child: dineInStarterWidget(
      //         StaticData.ckSpecialiTitle,
      //         StaticData.ckSpecialPrices,
      //         StaticData.ckSpecialImages,
      //         StaticData.ckSpecialDescriptions,
      //       ))
      //     else if (isSelected == 4)
      //       Expanded(
      //           child: dineInStarterWidget(
      //         StaticData.meatCurriesTitle,
      //         StaticData.meatCurriesPrices,
      //         StaticData.meatCurriesImages,
      //         StaticData.meatCurriesDescriptions,
      //       ))
      //     else if (isSelected == 5)
      //       Expanded(
      //           child: dineInStarterWidget(
      //         StaticData.veggieCurriesTitle,
      //         StaticData.veggieCurriesPrices,
      //         StaticData.veggieCurriesImages,
      //         StaticData.veggieCurriesDescriptions,
      //       ))
      //     else if (isSelected == 6)
      //       Expanded(
      //           child: dineInStarterWidget(
      //         StaticData.sizzlingBarbecueTitle,
      //         StaticData.sizzlingBarbecuePrices,
      //         StaticData.sizzlingBarbecueImages,
      //         StaticData.sizzlingBarbecueDescriptions,
      //       ))
      //     else if (isSelected == 7)
      //       Expanded(
      //           child: dineInStarterWidget(
      //         StaticData.bbqPlatterTitle,
      //         StaticData.bbqPlatterPrices,
      //         StaticData.bbqPlatterImages,
      //         StaticData.bbqPlatterDescriptions,
      //       ))
      //     else if (isSelected == 8)
      //       Expanded(
      //           child: dineInStarterWidget(
      //         StaticData.breadTitle,
      //         StaticData.breadPrices,
      //         StaticData.breadImages,
      //         StaticData.breadDescriptions,
      //       ))
      //     else if (isSelected == 9)
      //       Expanded(
      //           child: dineInStarterWidget(
      //         StaticData.drinksTitle,
      //         StaticData.drinksPrices,
      //         StaticData.drinksImages,
      //         StaticData.drinksDescriptions,
      //       ))
      //     else if (isSelected == 10)
      //       Expanded(
      //           child: dineInStarterWidget(
      //         StaticData.riceTitle,
      //         StaticData.ricePrices,
      //         StaticData.riceImages,
      //         StaticData.riceDescriptions,
      //       ))
      //     else if (isSelected == 11)
      //       Expanded(
      //           child: dineInStarterWidget(
      //         StaticData.desertTitle,
      //         StaticData.desertPrices,
      //         StaticData.desertImages,
      //         StaticData.desertDescriptions,
      //       ))
      //     else
      //       Expanded(
      //           child: dineInStarterWidget(
      //         StaticData.saladTitle,
      //         StaticData.saladPrices,
      //         StaticData.saladImages,
      //         StaticData.saladDescriptions,
      //       ))
      //   ],
      // ),
    );
  }

  Widget dineInStarterWidget(
    List titles,
    List prices,
    List images,
    List descriptions,
  ) {
    return GridView.builder(
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

  Widget getItemsWidget() {
    return StreamBuilder(
      stream: itemsStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return GridView.builder(
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
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
                      ), //BoxShadow
                      BoxShadow(
                        color: Colors.white,
                        offset: const Offset(0.0, 0.0),
                        blurRadius: 0.0,
                        spreadRadius: 0.0,
                      ), //BoxShadow
                    ],
                  ),
                  child: Column(
                    children: [
                      Expanded(
                          child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.network(
                          ds['image'],
                          fit: BoxFit.cover,
                        ),
                      )),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              ds['title'],
                              style: CustomTextStyles.mediumBlackColorStyle2,
                            ),
                            Text("\$" + ds['price']),
                          ],
                        ),
                      ),
                    ],
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
    );
  }

  _bulidProductCategory({required int index, required String name}) =>
      GestureDetector(
        onTap: () => setState(() => isSelected = index),
        child: Container(
          // width: 100,
          // height: 40,
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

  Widget dineInWidget2() {
    return GridView.builder(
      itemCount: StaticData.dineInStarterTitles.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return DineInDetailScreen(
                  itemTitle: StaticData.dineInStarterTitles[index],
                  price: StaticData.dineInStarterPrices[index],
                  imagePath: StaticData.dineInStarterImages[index],
                  description: StaticData.dineInStarterDescriptions[index],
                );
              },
            ));
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                decoration: BoxDecoration(
                    color: AppTheme.themeColor,
                    image: DecorationImage(
                        image:
                            AssetImage(StaticData.dineInStarterImages[index]))),
                // color: Color(0xffF6F5F2),
                child: Stack(
                  children: [
                    // Image.asset(dineInImages[index]),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${StaticData.dineInStarterTitles[index]}',
                            style: CustomTextStyles.mediumWhiteColorStyle,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 5,
                      bottom: 5,
                      child: Text(
                        '${StaticData.dineInStarterPrices[index]}',
                        style: CustomTextStyles.smallWhiteColorStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
