import 'package:dine_in/Views/Utils/Styles/text_styles.dart';
import 'package:dine_in/Views/Utils/Styles/theme.dart';
import 'package:flutter/material.dart';

class BookDineIn extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const BookDineIn({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: MediaQuery.sizeOf(context).width,
        height: 60,
        decoration: BoxDecoration(
          color: AppTheme.blackColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            '${text}',
            style: CustomTextStyles.bookDineInButtonStyle,
          ),
        ),
      ),
    );
  }
}
