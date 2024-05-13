import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dine_in/Controllers/database_services.dart';
import 'package:dine_in/Views/AdminSide/CategoriesScreens/add_category.dart';
import 'package:dine_in/Views/Utils/Styles/text_styles.dart';
import 'package:dine_in/Views/Utils/Styles/theme.dart';
import 'package:flutter/material.dart';

class AllCategoriesAdminScreen extends StatefulWidget {
  const AllCategoriesAdminScreen({super.key});

  @override
  State<AllCategoriesAdminScreen> createState() =>
      _AllCategoriesAdminScreenState();
}

class _AllCategoriesAdminScreenState extends State<AllCategoriesAdminScreen> {
  Stream? categoryStream;
  getCategories() async {
    categoryStream = await DatabaseServices().getData('categories');
    setState(() {});
  }

  @override
  void initState() {
    getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'All Categories',
          style: CustomTextStyles.appBarStyle,
        ),
      ),
      body: StreamBuilder(
        stream: categoryStream,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data.docs[index];
                return Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(ds['image']),
                        ),
                        title: Text(ds['title'].toString()),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.themeColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return AddCategoryAdmin();
            },
          ));
        },
        child: Icon(
          Icons.add,
          color: AppTheme.whiteColor,
        ),
      ),
    );
  }
}
