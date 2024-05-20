import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dine_in/Views/Utils/Styles/text_styles.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:text_area/text_area.dart';

import '../../../Controllers/database_services.dart';
import '../../Utils/Components/common_field.dart';
import '../../Utils/Components/login_button.dart';
import '../../Utils/Components/pick_image_widget.dart';
import '../../Utils/Styles/theme.dart';

class ItemDetailAdmin extends StatefulWidget {
  final String id;
  const ItemDetailAdmin({
    super.key,
    required this.id,
  });

  @override
  State<ItemDetailAdmin> createState() => _ItemDetailAdminState();
}

class _ItemDetailAdminState extends State<ItemDetailAdmin> {
  DatabaseServices controller = Get.put(DatabaseServices());
  String title = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Item Detail",
          style: CustomTextStyles.appBarStyle,
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('items')
            .doc(widget.id)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            DocumentSnapshot<Map<String, dynamic>>? ds = snapshot.data;
            title = ds!['title'];
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.network(
                        width: MediaQuery.sizeOf(context).width,
                        '${ds['image']}',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, top: 25, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '${ds['title']}',
                          style: CustomTextStyles.appBarStyle,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Price",
                              style: CustomTextStyles.mediumBlackColorStyle2,
                            ),
                            Text(
                              '\$${ds['price']}',
                              style: CustomTextStyles.mediumBlackColorStyle2,
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Description",
                          style: CustomTextStyles.mediumBlackColorStyle,
                        ),
                        Text(
                          '${ds['description']}',
                          style: CustomTextStyles.smallGreyColorStyle,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: AppTheme.themeColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            onPressed: () {
              Get.dialog(AlertDialog(
                content: Text(
                  "Are you sure you want to delete this?",
                ),
                title: Text("${title}"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text("No"),
                  ),
                  TextButton(
                    onPressed: () {
                      controller.deleteData(
                        widget.id,
                        'items',
                      );
                    },
                    child: Text("Yes"),
                  ),
                ],
              ));
            },
            child: Icon(
              Icons.delete,
              color: AppTheme.whiteColor,
            ),
          ),
          SizedBox(width: 10),
          FloatingActionButton(
            backgroundColor: AppTheme.themeColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            onPressed: () {
              Get.bottomSheet(ItemEditBottomSheet(id: widget.id));
            },
            child: Icon(
              Icons.edit,
              color: AppTheme.whiteColor,
            ),
          ),
        ],
      ),
    );
  }
}

class ItemEditBottomSheet extends StatefulWidget {
  final String id;
  const ItemEditBottomSheet({
    super.key,
    required this.id,
  });

  @override
  State<ItemEditBottomSheet> createState() => ItemEditBottomSheetState();
}

class ItemEditBottomSheetState extends State<ItemEditBottomSheet> {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(21),
          topRight: Radius.circular(21),
        ),
        color: AppTheme.whiteColor,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: key,
            child: SingleChildScrollView(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('items')
                    .doc(widget.id)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    DocumentSnapshot<Map<String, dynamic>>? ds = snapshot.data;
                    if (ds != null) {
                      titleController.text = ds['title'];
                      priceController.text = ds['price'];
                      descriptionController.text = ds['description'];
                      selectedValue = ds['category_id'];
                      imageUrlFireStore = ds['image'];
                    }

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PickImageWidget(
                          onPressed: () {
                            getImage();
                          },
                          image: image,
                          imageUrl: imageUrlFireStore,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Select a Category",
                                    style: CustomTextStyles.smallGreyColorStyle,
                                  ),
                                  DropdownButton(
                                    style:
                                        CustomTextStyles.smallBlackColorStyle,
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
                              String UniqueFileName = DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString();
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
                                imageUrlFireStore = await referenceImageToUpload
                                    .getDownloadURL();
                              } catch (e) {
                                print(e.toString());
                              }
                              String id = randomAlphaNumeric(7);
                              Map<String, dynamic> itemDetailsUpdate = {
                                'id': id,
                                'title': titleController.text.toString(),
                                'price': priceController.text.toString(),
                                'description':
                                    descriptionController.text.toString(),
                                'category_id': selectedValue,
                                'image': imageUrlFireStore,
                              };

                              await DatabaseServices()
                                  .UpdateItem(id, itemDetailsUpdate)
                                  .then((value) => {
                                        Fluttertoast.showToast(
                                            msg: 'Item Updated Successfully'),
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
                                    "Update Item",
                                    style: CustomTextStyles.commonButtonStyle,
                                  ),
                          ),
                        ),
                      ],
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
