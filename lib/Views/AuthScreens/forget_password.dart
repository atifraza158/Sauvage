import 'package:dine_in/Views/Utils/Components/common_field.dart';
import 'package:dine_in/Views/Utils/Components/login_button.dart';
import 'package:dine_in/Views/Utils/Styles/text_styles.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  TextEditingController emailcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 50,
                ),
                const Text(
                  'Forgot password',
                  style: CustomTextStyles.appBarStyle,
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  'Enter your email to forgot password',
                  style: CustomTextStyles.smallGreyColorStyle,
                ),
                const SizedBox(
                  height: 20,
                ),
                CommonTextField(
                  controller: emailcontroller,
                  validate: (val) {
                    if (val!.isEmpty) {
                      return "Email must be given";
                    } else if (!EmailValidator.validate(val)) {
                      return "In-Correct Email Format";
                    } else {
                      return null;
                    }
                  },
                  obsecureText: false,
                  hintText: 'johndoe@example.com',
                ),
                const SizedBox(
                  height: 25,
                ),
                CommonButton(
                  onPressed: () {},
                  child: Text(
                    'Submit',
                    style: CustomTextStyles.commonButtonStyle,
                  ),
                ),
              ],
            ),
            const Row(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info,
                  color: Colors.grey,
                  size: 30,
                ),
                SizedBox(width: 10),
                Flexible(
                  child: Text(
                    "You will recieve an email that will caontain a token to recover the forgot password!",
                    softWrap: true,
                    overflow: TextOverflow.visible,
                    style: CustomTextStyles.smallGreyColorStyle,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
