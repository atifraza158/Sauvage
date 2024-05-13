import 'package:dine_in/Views/Utils/Styles/text_styles.dart';
import 'package:dine_in/Views/Utils/Styles/theme.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.themeColor,
        title: Text(
          "My Account",
          style: CustomTextStyles.appBarWhiteStyle,
        ),
        
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                color: AppTheme.skyBlueThemeColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 45,
                      backgroundImage: AssetImage('assets/images/user.jpg'),
                    ),

                    SizedBox(width: 10),
                    // Column for name and email
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Johan Doe",
                          style: CustomTextStyles.mediumBlackColorStyle2,
                        ),
                        Text(
                          "johndoe@example.com",
                          style: CustomTextStyles.smallGreyColorStyle,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: icons.length,
                itemBuilder: (context, index) {
                  return tile(
                    titles[index],
                    icons[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // body: Padding(
      //   padding: const EdgeInsets.all(30),
      //   child: Center(
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //       crossAxisAlignment: CrossAxisAlignment.center,
      //       children: [
      //         Expanded(
      //           child: ClipRRect(
      //             borderRadius: BorderRadius.circular(14),
      //             child: Image.asset(
      //               'assets/images/user.jpg',
      //               fit: BoxFit.cover,
      //               width: MediaQuery.sizeOf(context).width,
      //             ),
      //           ),
      //         ),
      //         SizedBox(height: 20),

      //         // information of User
      //         Column(
      //           children: [
      //             Row(
      //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //               children: [
      //                 Text(
      //                   "Username",
      //                   style: CustomTextStyles.smallGreyColorStyle,
      //                 ),
      //                 Text(
      //                   'jamshed123',
      //                   style: CustomTextStyles.mediumBlackColorStyle2,
      //                 )
      //               ],
      //             ),
      //             SizedBox(height: 10),
      //             Padding(
      //               padding: const EdgeInsets.symmetric(horizontal: 20),
      //               child: Divider(),
      //             ),
      //             SizedBox(height: 10),
      //             Row(
      //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //               children: [
      //                 Text(
      //                   "Email Address",
      //                   style: CustomTextStyles.smallGreyColorStyle,
      //                 ),
      //                 Flexible(
      //                   child: Text(
      //                     'W.jamshedmalik@gmail.com',
      //                     style: CustomTextStyles.mediumBlackColorStyle2,
      //                   ),
      //                 )
      //               ],
      //             ),
      //             SizedBox(height: 10),
      //             Padding(
      //               padding: const EdgeInsets.symmetric(horizontal: 20),
      //               child: Divider(),
      //             ),
      //             SizedBox(height: 10),
      //             Row(
      //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //               children: [
      //                 Text(
      //                   "Contact No.",
      //                   style: CustomTextStyles.smallGreyColorStyle,
      //                 ),
      //                 Text(
      //                   '+1234567890',
      //                   style: CustomTextStyles.mediumBlackColorStyle2,
      //                 )
      //               ],
      //             ),
      //             SizedBox(height: 10),
      //           ],
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }

  tile(String text, IconData icon) {
    return GestureDetector(
      onTap: () {},
      child: ListTile(
        leading: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppTheme.themeColor,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              icon,
              color: AppTheme.whiteColor,
            ),
          ),
        ),
        title: Text(
          text.toString(),
          style: CustomTextStyles.mediumBlackColorStyle2,
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 20,
        ),
      ),
    );
  }

  List icons = [
    Icons.lock,
    Icons.notification_add,
    Icons.question_answer,
    Icons.contact_phone,
    Icons.edit_document,
    Icons.logout,
  ];

  List titles = [
    'Forget Password',
    'Notifications',
    'FAQ\'s',
    'Contact Us',
    'Terms & Conditions',
    'Logout'
  ];
}
