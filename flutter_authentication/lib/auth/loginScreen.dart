import 'package:flutter/material.dart';
import 'package:flutter_authentication/auth/signupScreen.dart';
import 'package:flutter_authentication/provider/authProvider.dart';
import 'package:flutter_authentication/theme/changeTheme.dart';
import 'package:flutter_authentication/theme/easyLoading.dart';
import 'package:flutter_authentication/utility/customSnackBar.dart';
import 'package:flutter_authentication/views/homeScreen.dart';
import 'package:flutter_authentication/widgets/buttons.widgets.dart';
import 'package:flutter_authentication/widgets/image.widgets.dart';
import 'package:flutter_authentication/widgets/textfiled.widget.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  bool rememberMe = false;
  bool canSeePassword = true;
  _navigate(BuildContext context) {
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) {
        return const HomeScreen();
      },
    ));
  }

  Future<void> _saveLoginDetails(String email, String password) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('password', password);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    Authprovider authProvider = Get.find<Authprovider>();

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
                          "Welcome Back!",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: width * 0.05),
                        ),
                      ),
                      Text(
                        "Enter your credentials to access your account.",
                        style: TextStyle(
                            fontSize: width * 0.04,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.05,
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
                        CustomTextField(
                          labelText: "Enter Password  ",
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
                          showPassword: () {
                            setState(() {
                              canSeePassword = !canSeePassword;
                            });
                          },
                          obscureText: canSeePassword,
                          controller: _passwordController,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Checkbox(
                                  value: rememberMe,
                                  onChanged: (value) {
                                    setState(() {
                                      rememberMe = !rememberMe;
                                    });
                                  },
                                  activeColor:
                                      const Color.fromARGB(255, 64, 135, 193),
                                ),
                                const Text(
                                  "Remember Me",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return SignUpScreen(
                                      isForgotPassword: true,
                                    );
                                  },
                                ));
                              },
                              child: Text(
                                "Forgot Password?",
                                style: TextStyle(
                                    color: ThemeClass.isDarkMode(context)
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                    decorationThickness: 2.5),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        CustomButton(
                          text: "SIGN IN",
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                LoadingIndicator.show();

                                final email = _emailController.text.trim();
                                final password =
                                    _passwordController.text.trim();
                                final isCorrectCredential = await Authprovider()
                                    .loginUser(email, password, context);

                                if (isCorrectCredential) {
                                  authProvider.setEmail(email);
                                  authProvider.setPassword(password);
                                  if (rememberMe) {
                                    await _saveLoginDetails(email, password);
                                  }
                                  _navigate(context);
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
                              CustomSnackbar(
                                      text: "Enter Valid Data",
                                      color: Colors.red)
                                  .show(context);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  CustomTextRow(
                      firstText: "Don't have an account?",
                      secondText: "SIGN UP",
                      onTap: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) {
                            return SignUpScreen(
                              isForgotPassword: false,
                            );
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
