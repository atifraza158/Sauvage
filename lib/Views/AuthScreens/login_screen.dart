import 'package:dine_in/Controllers/database_services.dart';
import 'package:dine_in/Views/AuthScreens/forget_password.dart';
import 'package:dine_in/Views/AuthScreens/register_screen.dart';
import 'package:dine_in/Views/Utils/Components/login_button.dart';
import 'package:dine_in/Views/Utils/Styles/text_styles.dart';
import 'package:dine_in/Views/Utils/Styles/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../UserSide/DrawerScreens/user_drawer_screen.dart';
import '../Utils/Components/common_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formkey = GlobalKey<FormState>();
  var emailcontroller = TextEditingController();
  var passwordcontroller = TextEditingController();

  bool isLoading = false;
  bool show = false;
  bool loader = false;

  DatabaseServices controller = Get.put(DatabaseServices());

  void showPassword() {
    if (show) {
      show = false;
    } else {
      show = true;
    }

    setState(() {});
  }

  FirebaseAuth _auth = FirebaseAuth.instance;

  void login(String email, String password) {
    _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      Fluttertoast.showToast(msg: value.user!.email.toString());
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return UserDrawerScreen();
        },
      ));
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      Fluttertoast.showToast(msg: "Incorrect Credientials");
    });
  }

  @override
  void initState() {
    super.initState();
    show = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: -50,
            right: -10,
            child: Container(
              height: 300,
              width: 250,
              decoration: BoxDecoration(
                color: AppTheme.themeColor,
                borderRadius:
                    BorderRadius.only(bottomLeft: Radius.circular(250)),
              ),
            ),
          ),
          Form(
            key: _formkey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome back',
                    style: CustomTextStyles.titleStyle,
                  ),
                  const Text(
                    'Sign in your account to continue',
                    style: CustomTextStyles.smallGreyColorStyle,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  const Text(
                    'Email Id',
                    style: CustomTextStyles.simpleFontFamily,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  CommonTextField(
                    ketboardType: TextInputType.emailAddress,
                    hintText: "johndoe@example.com",
                    controller: emailcontroller,
                    validate: (val) {
                      if (val!.isEmpty) {
                        return 'Email can\'t empty';
                      } else {
                        return null;
                      }
                    },
                    obsecureText: false,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    'Password',
                    style: CustomTextStyles.simpleFontFamily,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  CommonTextField(
                    hintText: "***********",
                    controller: passwordcontroller,
                    ketboardType: TextInputType.text,
                    validate: (val) {
                      if (val!.isEmpty) {
                        return "Password field cannot be empty";
                      } else {
                        return null;
                      }
                    },
                    icon: IconButton(
                      icon: show
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.visibility),
                      onPressed: showPassword,
                    ),
                    obsecureText: show ? false : true,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return ForgetPasswordScreen();
                            },
                          ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: const Text(
                            'Forgot Password',
                            style: CustomTextStyles.smallThemedColorStyle,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                    ),
                    child: CommonButton(
                      child: Obx(
                        () => controller.loader.isTrue
                            ? CircularProgressIndicator(
                                color: AppTheme.whiteColor,
                              )
                            : Text(
                                'Login',
                                style: CustomTextStyles.commonButtonStyle,
                              ),
                      ),
                      onPressed: () {
                        if (_formkey.currentState!.validate()) {
                          controller.signInWithEmailAndPassword(
                            emailcontroller.text,
                            passwordcontroller.text,
                          );
                        } else {}
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account?",
                  style: CustomTextStyles.smallGreyColorStyle,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return RegisterScreen();
                      },
                    ));
                  },
                  child: const Text(
                    'SignUp',
                    style: CustomTextStyles.smallThemedColorStyle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
