import 'package:flutter/material.dart';
import 'package:flutter_authentication/auth/loginScreen.dart';
import 'package:flutter_authentication/auth/otpVerificationScreen.dart';
import 'package:flutter_authentication/provider/authProvider.dart';
import 'package:flutter_authentication/theme/easyLoading.dart';
import 'package:flutter_authentication/utility/customSnackBar.dart';
import 'package:flutter_authentication/widgets/buttons.widgets.dart';
import 'package:flutter_authentication/widgets/image.widgets.dart';
import 'package:flutter_authentication/widgets/textfiled.widget.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key, required this.isForgotPassword});
  bool isForgotPassword;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  Authprovider authProvider = Get.find<Authprovider>();

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
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          isForgotPassword
                              ? "Forgot Password"
                              : "Create New Account",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.06,
                          ),
                        ),
                      ),
                      Text(
                        isForgotPassword
                            ? "Enter your email address to receive a verification code and reset your password."
                            : "Enter your email to receive a verification Code.",
                        style: TextStyle(
                          fontSize: width * 0.04,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomTextField(
                          labelText: "Email",
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Email is required";
                            }
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$')
                                .hasMatch(value)) {
                              return "Enter a valid email";
                            }
                            return null;
                          },
                          controller: _emailController,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        CustomArrowButton(
                          text: "GET VERIFICATION CODE",
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                LoadingIndicator.show();

                                final email = _emailController.text.trim();
                                bool isOtpSent = false;
                                if (isForgotPassword) {
                                  isOtpSent = await Authprovider()
                                      .forgotPassword(email, context);
                                } else {
                                  isOtpSent = await Authprovider()
                                      .sendOtp(email, context);
                                }
                                if (isOtpSent) {
                                  authProvider.setEmail(email);

                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          OtpVerificationScreen(
                                        isForgotPassword: isForgotPassword,
                                      ),
                                    ),
                                  );
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
                              final errorMessage = _emailController.text.isEmpty
                                  ? "Email is required"
                                  : "Enter a valid email";

                              CustomSnackbar(
                                text: errorMessage,
                                color: Colors.red,
                              ).show(context);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  if (!isForgotPassword)
                    CustomTextRow(
                        firstText: "Already have an account?",
                        secondText: "SIGN IN",
                        onTap: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (context) {
                              return LoginScreen();
                            },
                          ));
                        }),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
