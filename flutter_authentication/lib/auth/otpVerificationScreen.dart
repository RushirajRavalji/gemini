import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_authentication/auth/setPasswordScreen.dart';
import 'package:flutter_authentication/provider/authProvider.dart';
import 'package:flutter_authentication/theme/easyLoading.dart';
import 'package:flutter_authentication/utility/customSnackBar.dart';
import 'package:flutter_authentication/widgets/buttons.widgets.dart';
import 'package:flutter_authentication/widgets/image.widgets.dart';
import 'package:flutter_authentication/widgets/textfiled.widget.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class OtpVerificationScreen extends StatefulWidget {
  OtpVerificationScreen({super.key, required this.isForgotPassword});
  bool isForgotPassword;

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _OTPController = TextEditingController();
  Authprovider authProvider = Get.find<Authprovider>();

  //// Timer for resend code

  bool isButtonEnabled = true;
  late Timer _timer;
  int remainingTime = 150;

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    setState(() {
      isButtonEnabled = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingTime > 0) {
          remainingTime--;
        } else {
          timer.cancel();
          isButtonEnabled = true;
          remainingTime = 150;
        }
      });
    });
  }

  @override
  void initState() {
    startTimer();
    super.initState();
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
                          "Enter Verification Code",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.055,
                          ),
                        ),
                      ),
                      Text(
                        widget.isForgotPassword
                            ? "We have sent verification code to *****@gmail.com. \n"
                                "Please enter it below to reset your password."
                            : "We have sent verification code to *****@gmail.com. \n"
                                "Please enter it below to verify your account.",
                        style: TextStyle(
                          fontSize: width * 0.04,
                          fontWeight: FontWeight.w500,
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
                          labelText: "Enter Code",
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Code is required";
                            }
                            if (!RegExp(r'^\d{4}$').hasMatch(value)) {
                              return "Enter a valid Code";
                            }
                            return null;
                          },
                          controller: _OTPController,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            height: height * 0.05,
                            width: width * 0.3,
                            decoration: BoxDecoration(
                              color: isButtonEnabled
                                  ? Color.fromARGB(255, 64, 135, 193)
                                  : Colors.grey,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: InkWell(
                              onTap: isButtonEnabled
                                  ? () async {
                                      try {
                                        LoadingIndicator.show();

                                        final email = authProvider.getEmail;
                                        print(email);
                                        bool isOtpSent = false;
                                        if (widget.isForgotPassword) {
                                          isOtpSent = await Authprovider()
                                              .forgotPassword(email, context);
                                        } else {
                                          isOtpSent = await Authprovider()
                                              .sendOtp(email, context);
                                        }

                                        if (isOtpSent) {
                                          startTimer();
                                        }
                                      } catch (e) {
                                        CustomSnackbar(
                                          text: "Something went wrong.",
                                          color: Colors.red,
                                        ).show(context);
                                      } finally {
                                        LoadingIndicator.dismiss();
                                      }
                                    }
                                  : null,
                              child: Center(
                                child: Text(
                                  isButtonEnabled
                                      ? "Resend Code"
                                      : "Wait  ${remainingTime ~/ 60}:${(remainingTime % 60).toString().padLeft(2, '0')}", // Countdown text
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        CustomArrowButton(
                          text: "VERIFY CODE",
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                setState(() {
                                  _timer.cancel();
                                  isButtonEnabled = true;
                                });

                                LoadingIndicator.show();
                                final otp = _OTPController.text.trim();
                                final email = authProvider.getEmail;
                                final isCorrect = await Authprovider()
                                    .verifyOtp(email, otp, context);

                                if (isCorrect) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SetPasswordScreen(
                                          isForgotPassword:
                                              widget.isForgotPassword),
                                    ),
                                  );
                                }
                              } catch (e) {
                                CustomSnackbar(
                                        text: "Something went wrong.",
                                        color: Colors.red)
                                    .show(context);
                              } finally {
                                LoadingIndicator.dismiss();
                              }
                            } else {
                              if (_OTPController.text.isEmpty) {
                                CustomSnackbar(
                                        text: "Code is required",
                                        color: Colors.red)
                                    .show(context);
                              } else {
                                CustomSnackbar(
                                        text: "Enter Valid Code",
                                        color: Colors.red)
                                    .show(context);
                              }
                            }
                          },
                        ),
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
