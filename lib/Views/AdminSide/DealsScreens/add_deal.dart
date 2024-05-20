import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dine_in/Controllers/database_services.dart';
import 'package:dine_in/Views/AdminSide/DealsScreens/all_deals_admin.dart';
import 'package:dine_in/Views/Utils/Styles/theme.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:text_area/text_area.dart';

import '../../../Controllers/deal_items_controlller.dart';
import '../../Utils/Components/common_field.dart';
import '../../Utils/Components/login_button.dart';
import '../../Utils/Components/pick_image_widget.dart';
import '../../Utils/Styles/text_styles.dart';

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

  var selectedValue;

  String imageUrlFireStore = '';
  var reasonValidation = false;

  DatabaseServices controller = Get.put(DatabaseServices());
  ItemController itemsController = Get.put(ItemController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Deal",
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Select items to add",
                        style: CustomTextStyles.smallGreyColorStyle,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.themeColor),
                        onPressed: () {
                          Get.bottomSheet(AllItemsBottomSheet());
                        },
                        child: Row(
                          children: [
                            Text(
                              "Items",
                              style: CustomTextStyles.smallWhiteColorStyle,
                            ),
                            Icon(
                              Icons.arrow_drop_down_rounded,
                              color: AppTheme.whiteColor,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
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
                      print(itemsController.selectedItems);

                      if (key.currentState!.validate()) {
                        // Create unique file name with time stamp
                        String UniqueFileName =
                            DateTime.now().millisecondsSinceEpoch.toString();
                        // Creating instance of Firebase Cloud
                        Reference referenceRoot =
                            FirebaseStorage.instance.ref();
                        // Creating here images folder inside the Firebase Cloud
                        Reference referenceDirImages =
                            referenceRoot.child('dealImages');

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
                        Map<String, dynamic> dealDetails = {
                          'id': id,
                          'title': titleController.text.toString(),
                          'price': priceController.text.toString(),
                          'description': descriptionController.text.toString(),
                          'image': imageUrlFireStore,
                          'items': itemsController.selectedItems,
                        };

                        await DatabaseServices()
                            .addData(dealDetails, id, 'deals')
                            .then((value) => {
                                  Fluttertoast.showToast(
                                    msg: 'Deal Created Successfully',
                                  ),
                                  itemsController.selectedItems = [],
                                  Get.off(() => AllDealsAdminScreen()),
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

class AllItemsBottomSheet extends StatefulWidget {
  const AllItemsBottomSheet({super.key});

  @override
  State<AllItemsBottomSheet> createState() => _AllItemsBottomSheetState();
}

class _AllItemsBottomSheetState extends State<AllItemsBottomSheet> {
  final ItemController itemsController = Get.put(ItemController());
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      height: 500,
      decoration: BoxDecoration(
          color: AppTheme.whiteColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(21),
            topRight: Radius.circular(21),
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "All Items",
                  style: CustomTextStyles.appBarStyle,
                ),
                Text(
                  "Select Items to add in the Deal",
                  style: CustomTextStyles.smallGreyColorStyle,
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('items').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot ds = snapshot.data!.docs[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.greyColor,
                                offset: const Offset(
                                  2.0,
                                  1.0,
                                ),
                                blurRadius: 9.0,
                                spreadRadius: 0.0,
                              ),
                              BoxShadow(
                                color: Colors.white,
                                offset: const Offset(0.0, 0.0),
                                blurRadius: 0.0,
                                spreadRadius: 0.0,
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(ds['image']),
                              ),
                              title: Text(ds['title']),
                              trailing: IconButton(
                                onPressed: () {
                                  itemsController.toggleSelected(ds.id);
                                },
                                icon: Icon(
                                  itemsController.selectedItems.contains(ds.id)
                                      ? Icons.check
                                      : Icons.add,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(child: Text('No data'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
