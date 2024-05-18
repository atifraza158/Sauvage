import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dine_in/Views/AdminSide/ItemsScreens/all_items_admin.dart';
import 'package:dine_in/Views/Utils/Components/common_field.dart';
import 'package:dine_in/Views/Utils/Components/login_button.dart';
import 'package:dine_in/Views/Utils/Styles/text_styles.dart';
import 'package:dine_in/Views/Utils/Styles/theme.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:text_area/text_area.dart';

import '../../../Controllers/database_services.dart';
import '../../Utils/Components/pick_image_widget.dart';

class AddItem extends StatefulWidget {
  const AddItem({super.key});

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  TextEditingController titleController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DatabaseServices controller = Get.put(DatabaseServices());

  final key = GlobalKey<FormState>();
  File? image;

  var reasonValidation = false;
  var value = '1';

  String imageUrlFireStore = '';
  var selectedValue;

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
                  // Container(
                  //   width: MediaQuery.sizeOf(context).width,
                  //   height: 70,
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(14),
                  //     color: AppTheme.skyBlueThemeColor,
                  //   ),
                  //   child: DropdownButton(items: List.generate(5, (index) => {}), onChanged: (String? newValue) {
                  //     setState(() {
                  //       value = newValue!;
                  //     });
                  //   }),
                  // ),
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
                        .collection('categories')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<DropdownMenuItem> categoriesNames = [];
                        snapshot.data!.docs.forEach((category) {
                          categoriesNames.add(
                            DropdownMenuItem(
                              child: Text(category['title']),
                              value: category['id'],
                            ),
                          );
                        });
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Select a Category",
                              style: CustomTextStyles.smallGreyColorStyle,
                            ),
                            DropdownButton(
                              style: CustomTextStyles.smallBlackColorStyle,
                              items: categoriesNames,
                              value: selectedValue,
                              onChanged: (categoryValue) {
                                setState(() {
                                  selectedValue = categoryValue;
                                });
                              },
                            ),
                          ],
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
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
                      if (key.currentState!.validate()) {
                        // Create unique file name with time stamp
                        String UniqueFileName =
                            DateTime.now().millisecondsSinceEpoch.toString();
                        // Creating instance of Firebase Cloud
                        Reference referenceRoot =
                            FirebaseStorage.instance.ref();
                        // Creating here images folder inside the Firebase Cloud
                        Reference referenceDirImages =
                            referenceRoot.child('ItemImages');

                        // Passing the name to the uploaded image
                        Reference referenceImageToUpload =
                            referenceDirImages.child(UniqueFileName);

                        try {
                          // Uploading the image to Firebase Cloud, with path
                          await referenceImageToUpload
                              .putFile(File(image!.path));
                          imageUrlFireStore =
                              await referenceImageToUpload.getDownloadURL();
                        } catch (e) {
                          //  Handle Errors here..
                        }
                        String id = randomAlphaNumeric(7);
                        Map<String, dynamic> itemDetails = {
                          'id': id,
                          'title': titleController.text.toString(),
                          'price': priceController.text.toString(),
                          'description': descriptionController.text.toString(),
                          'category_id': selectedValue,
                          'image': imageUrlFireStore,
                        };

                        await DatabaseServices()
                            .addData(itemDetails, id, 'items')
                            .then((value) => {
                                  Fluttertoast.showToast(
                                      msg: 'Item Added Successfully'),
                                  Get.off(() => AllItemsAdmin()),
                                });
                      }
                    },
                    child: Obx(
                      () => controller.loader.isTrue
                          ? Center(
                              child: CircularProgressIndicator(
                                color: AppTheme.whiteColor,
                              ),
                            )
                          : Text(
                              "Add Item",
                              style: CustomTextStyles.commonButtonStyle,
                            ),
                    ),
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
                "The selected image is too large. Please choose an image smaller than 2MB.");
      }
    }
  }
}
