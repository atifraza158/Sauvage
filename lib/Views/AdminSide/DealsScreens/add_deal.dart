import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:text_area/text_area.dart';

import '../../Utils/Components/common_field.dart';
import '../../Utils/Components/login_button.dart';
import '../../Utils/Components/pick_image_widget.dart';
import '../../Utils/Styles/text_styles.dart';
import '../../Utils/Styles/theme.dart';

class AddDeal extends StatefulWidget {
  const AddDeal({super.key});

  @override
  State<AddDeal> createState() => _AddDealState();
}

class _AddDealState extends State<AddDeal> {
  TextEditingController titleController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  final key = GlobalKey<FormState>();
  File? image;

  String imageUrlFireStore = '';
  var reasonValidation = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Item",
          style: CustomTextStyles.appBarStyle,
        ),
      ),
      body: Form(
        key: key,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PickImageWidget(
                    onPressed: () {
                      getImage();
                    },
                    image: image,
                  ),
                  SizedBox(height: 10),
                  CommonTextField(
                    controller: titleController,
                    validate: (val) {
                      if (val == null || val.isEmpty) {
                        return "Title is necessary";
                      }
                      return null;
                    },
                    obsecureText: false,
                    hintText: "Title of Item",
                  ),
                  const SizedBox(height: 10),
                  CommonTextField(
                    controller: priceController,
                    hintText: "Price",
                    validate: (val) {
                      if (val == null || val.isEmpty) {
                        return "Price is necessary";
                      }
                      return null;
                    },
                    obsecureText: false,
                  ),
                  const SizedBox(height: 10),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('category')
                        .snapshots(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      List<DropdownMenuItem> categoriesNames = [];
                      if (snapshot.hasData) {
                        final categories = snapshot.data.docs.reversed.toList();
                        for (var i = 0; i < categories; i++) {
                          categoriesNames.add(DropdownMenuItem(
                            child: Text(
                              categories['name'],
                            ),
                            value: categories.name.toString(),
                          ));
                        }
                      } else {
                        const Center(
                          child: CircularProgressIndicator(
                            color: AppTheme.themeColor,
                          ),
                        );
                      }
                      return DropdownButton(
                        items: categoriesNames,
                        onChanged: (categoryValue) {
                          print(categoryValue);
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  TextArea(
                    borderRadius: 10,
                    borderColor: const Color(0xFFCFD6FF),
                    textEditingController: descriptionController,
                    onSuffixIconPressed: () => {},
                    validation: reasonValidation,
                    errorText: 'Please type a description!',
                  ),
                  SizedBox(height: 20),
                  CommonButton(
                    onPressed: () async {
                      // if (key.currentState!.validate()) {
                      //   // Create unique file name with time stamp
                      //   String UniqueFileName =
                      //       DateTime.now().millisecondsSinceEpoch.toString();
                      //   // Creating instance of Firebase Cloud
                      //   Reference referenceRoot =
                      //       FirebaseStorage.instance.ref();
                      //   // Creating here images folder inside the Firebase Cloud
                      //   Reference referenceDirImages =
                      //       referenceRoot.child('ItemImages');

                      //   // Passing the name to the uploaded image
                      //   Reference referenceImageToUpload =
                      //       referenceDirImages.child(UniqueFileName);

                      //   try {
                      //     // Uploading the image to Firebase Cloud, with path
                      //     await referenceImageToUpload
                      //         .putFile(File(image!.path));
                      //     imageUrlFireStore =
                      //         await referenceImageToUpload.getDownloadURL();
                      //   } catch (e) {
                      //     //  Handle Errors here..
                      //   }
                      //   String id = randomAlphaNumeric(7);
                      //   Map<String, dynamic> itemDetails = {
                      //     'id': id,
                      //     'title': titleController.text.toString(),
                      //     'price': priceController.text.toString(),
                      //     'description': descriptionController.text.toString(),
                      //     'image': imageUrlFireStore,
                      //   };

                      //   await DatabaseServices()
                      //       .addData(itemDetails, id, 'items')
                      //       .then((value) => {
                      //             Fluttertoast.showToast(
                      //                 msg: 'Item Added Successfully'),
                      //             Navigator.pushReplacement(context,
                      //                 MaterialPageRoute(
                      //               builder: (context) {
                      //                 return AllItemsAdmin();
                      //               },
                      //             ))
                      //           });
                      // }
                    },
                    child: const Text(
                      "Add Item",
                      style: CustomTextStyles.commonButtonStyle,
                    ),
                  )
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
                "The selected image is too large. Please choose an image smaller than 2MB.");
      }
    }
  }
}
