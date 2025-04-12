import 'package:flutter/material.dart';
import 'package:flutter_authentication/auth/loginScreen.dart';
import 'package:flutter_authentication/auth/signupScreen.dart';
import 'package:flutter_authentication/widgets/image.widgets.dart';
import 'package:flutter_authentication/widgets/buttons.widgets.dart';

class OptionScreen extends StatelessWidget {
  const OptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      body: Stack(
        children: [
          const TopRightSvg(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: height * 0.15,
              ),
              CustomImage(size: 0.45),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  "AI has been the focus of my life's work, as for many of my research colleagues. \n\n"
                  "Ever since programming AI for computer games as a teenager, and throughout my years as a "
                  "neuroscience researcher trying to understand the workings of the brain, I’ve always believed that"
                  "if we could build smarter machines, we could harness them to benefit humanity in incredible ways. \n\n"
                  "Gemini is your trusted partner for managing personal and professional goals effortlessly.",
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5, // Line height for better readability
                  ),
                ),
              ),
            ],
          ),
          const BottomLeftSvg(), // Using the reusable widget
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding:
                  EdgeInsets.only(bottom: height * 0.13, left: 15, right: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomButton(
                    text: "SIGN IN",
                    onTap: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) {
                          return LoginScreen();
                        },
                      ));
                    },
                  ),
                  CustomButton(
                    text: "SIGN UP",
                    onTap: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) {
                          return SignUpScreen(
                            isForgotPassword: false,
                          );
                        },
                      ));
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
