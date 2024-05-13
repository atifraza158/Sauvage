import 'dart:io';

import 'package:dine_in/Views/Utils/Styles/text_styles.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PickImageWidget extends StatefulWidget {
  final File? image;
  final String? imageUrl;
  final VoidCallback onPressed;

  const PickImageWidget({
    Key? key,
    this.image,
    this.imageUrl,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<PickImageWidget> createState() => _PickImageWidgetState();
}

class _PickImageWidgetState extends State<PickImageWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: DottedBorder(
        color: Colors.black,
        strokeWidth: 1,
        radius: Radius.circular(25),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 120,
          decoration: BoxDecoration(),
          child: widget.image != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    widget.image!,
                    fit: BoxFit.cover,
                  ),
                )
              : (widget.imageUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        widget.imageUrl!,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(FontAwesomeIcons.plus),
                        Text(
                          "Pick A Category Image",
                          style: CustomTextStyles.smallGreyColorStyle,
                        ),
                      ],
                    )),
        ),
      ),
    );
  }
}
