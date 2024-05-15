import 'dart:async';
import 'dart:io';

import 'package:dine_in/Controllers/database_services.dart';
import 'package:dine_in/Views/AdminSide/CategoriesScreens/all_categories.dart';
import 'package:dine_in/Views/Utils/Components/common_field.dart';
import 'package:dine_in/Views/Utils/Components/login_button.dart';
import 'package:dine_in/Views/Utils/Components/pick_image_widget.dart';
import 'package:dine_in/Views/Utils/Styles/text_styles.dart';
import 'package:dine_in/Views/Utils/Styles/theme.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class AddCategoryAdmin extends StatefulWidget {
  const AddCategoryAdmin({super.key});

  @override
  State<AddCategoryAdmin> createState() => _AddCategoryAdminState();
}

class _AddCategoryAdminState extends State<AddCategoryAdmin> {
  final key = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  String imagePath = '';
  File? image;
  String imageUrlFireStore = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: key,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Add Category",
                    style: CustomTextStyles.appBarStyle,
                  ),
                  Text(
                    'Add Category title and an Image',
                    style: CustomTextStyles.smallGreyColorStyle,
                  ),
                  SizedBox(height: 50),
                  PickImageWidget(
                    onPressed: () {
                      getImage();
                    },
                    image: image,
                  ),
                  SizedBox(height: 10),
                  CommonTextField(
                    controller: titleController,
                    validate: (value) {
                      if (value!.isEmpty) {
                        return 'Title is required';
                      } else {
                        return null;
                      }
                    },
                    hintText: 'Title of Catgory (i,e. Pizza)',
                    obsecureText: false,
                  ),
                  SizedBox(height: 50),
                  CommonButton(
                    child: DatabaseServices().loader.isTrue
                        ? Center(
                            child: CircularProgressIndicator(
                              color: AppTheme.whiteColor,
                            ),
                          )
                        : Text(
                            'Add Category',
                            style: CustomTextStyles.commonButtonStyle,
                          ),
                    onPressed: () async {
                      if (key.currentState!.validate()) {
                        // Create unique file name with time stamp
                        String UniqueFileName =
                            DateTime.now().millisecondsSinceEpoch.toString();
                        // Creating instance of Firebase Cloud
                        Reference referenceRoot =
                            FirebaseStorage.instance.ref();
                        // Creating here images folder inside the Firebase Cloud
                        Reference referenceDirImages =
                            referenceRoot.child('images');

                        // Passing the name to the uploaded image
                        Reference referenceImageToUpload =
                            referenceDirImages.child(UniqueFileName);

                        try {
                          // Uploading the image , with path
                          await referenceImageToUpload
                              .putFile(File(image!.path));
                          imageUrlFireStore =
                              await referenceImageToUpload.getDownloadURL();
                        } catch (e) {
                          //  Handle Errors here..
                        }
                        String id = randomAlphaNumeric(5);
                        Map<String, dynamic> categoryDetails = {
                          'title': titleController.text.toString(),
                          'id': id,
                          'image': imageUrlFireStore,
                        };

                        await DatabaseServices()
                            .addData(categoryDetails, id, 'categories')
                            .then((value) => {
                                  Fluttertoast.showToast(
                                      msg: 'Category Added Successfully'),
                                  Get.offAll(AllCategoriesAdminScreen()),
                                });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File tempImage = File(pickedFile.path);

      int fileSize = await tempImage.length();
      if (fileSize <= 2 * 1024 * 1024) {
        image = tempImage;
        debugPrint("Image path: ${image!.path}");
        setState(() {});
      } else {
        Fluttertoast.showToast(
          msg:
              "The selected image is too large. Please choose an image smaller than 2MB.",
        );
      }
    }
  }
}
