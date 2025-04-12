import 'package:flutter/material.dart';
import 'package:flutter_authentication/provider/authProvider.dart';
import 'package:flutter_authentication/theme/easyLoading.dart';
import 'package:flutter_authentication/utility/customDailogBox.dart';
import 'package:flutter_authentication/utility/customSnackBar.dart';
import 'package:flutter_authentication/views/homeScreen.dart';
import 'package:flutter_authentication/widgets/buttons.widgets.dart';
import 'package:flutter_authentication/widgets/image.widgets.dart';
import 'package:flutter_authentication/widgets/textfiled.widget.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetNewPassword extends StatelessWidget {
  SetNewPassword({super.key});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  _saveLoginInfoOrNot(BuildContext context, String email, String password) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomDialogBox(
          description: "Save Your Login Details?",
          onConfirm: () async {
            _saveLoginDetails(email, password);
            Navigator.of(context).pop();
            _navigate(context);
          },
          onCancel: () {
            Navigator.of(context).pop();
            _navigate(context);
          },
        );
      },
    );
  }

  Future<void> _saveLoginDetails(String email, String password) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('password', password);
  }

  _navigate(BuildContext context) {
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) {
        return const HomeScreen();
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    final authProvider = Get.find<Authprovider>();
    return Scaffold(
      body: SingleChildScrollView(
          child: Stack(
        children: [
          const TopRightSvg(),
          const BottomLeftSvg(),
          SizedBox(
            height: height,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.025, vertical: height * 0.15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomImage(size: 0.4),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          "Set New Password",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.06,
                          ),
                        ),
                      ),
                      Text(
                        "Your password must be at least 8 characters long and include at least one letter, one digit, and one special character (!@#\$%^&*).",
                        style: TextStyle(
                          fontSize: width * 0.04,
                          fontWeight: FontWeight.w500,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.025,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomTextField(
                          labelText: "Enter Old Password",
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Password is required";
                            }
                            if (!RegExp(
                                    r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{8,}$')
                                .hasMatch(value)) {
                              return "Enter a valid password";
                            }
                            return null;
                          },
                          controller: _oldPasswordController,
                        ),
                        CustomTextField(
                          labelText: "Enter New Password",
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Password is required";
                            }
                            if (!RegExp(
                                    r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{8,}$')
                                .hasMatch(value)) {
                              return "Enter a valid password";
                            }
                            return null;
                          },
                          controller: _passwordController,
                        ),
                        CustomTextField(
                          labelText: "Conform New Password",
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Password is required";
                            }
                            if (!RegExp(
                                    r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{8,}$')
                                .hasMatch(value)) {
                              return "Enter a valid password";
                            }
                            return null;
                          },
                          controller: _confirmPasswordController,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        CustomButton(
                          text: "SET NEW PASSWORD",
                          onTap: () async {
                            if (_formKey.currentState!.validate() &&
                                _passwordController.text ==
                                    _confirmPasswordController.text) {
                              try {
                                LoadingIndicator.show();

                                final email = authProvider.getEmail;
                                bool isChanged = false;

                                isChanged = await Authprovider().changePassword(
                                    email,
                                    _oldPasswordController.text.trim(),
                                    _passwordController.text.trim(),
                                    context);

                                if (isChanged) {
                                  _saveLoginInfoOrNot(context, email,
                                      _passwordController.text.trim());
                                }
                              } catch (e) {
                                CustomSnackbar(
                                  text: "Something went wrong.",
                                  color: Colors.red,
                                ).show(context);
                              } finally {
                                LoadingIndicator.dismiss();
                              }
                            } else {
                              if (_passwordController.text.isEmpty) {
                                CustomSnackbar(
                                        text: "Password is required",
                                        color: Colors.red)
                                    .show(context);
                              } else if (_passwordController.text.toString() !=
                                  _confirmPasswordController.text.toString()) {
                                CustomSnackbar(
                                        text:
                                            "Password and conform password must be same",
                                        color: Colors.red)
                                    .show(context);
                              } else {
                                CustomSnackbar(
                                        text: "Enter Valid Password",
                                        color: Colors.red)
                                    .show(context);
                              }
                            }
                          },
                        ),
                        SizedBox(
                          height: height * 0.02,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
