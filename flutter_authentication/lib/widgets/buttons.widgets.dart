import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const CustomButton({Key? key, required this.text, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 64, 135, 193),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}


class CustomTextRow extends StatelessWidget {
  final String firstText; // The first text before the link (e.g., "Don't have an account?")
  final String secondText; // The second text that acts as the clickable link (e.g., "Sign Up")
  final VoidCallback onTap; // The function to execute when the second text is tapped

  const CustomTextRow({
    required this.firstText,
    required this.secondText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          firstText,
        ),
        TextButton(
          onPressed: onTap,
          child: Text(
            secondText,
            style: const TextStyle(
              color: Color.fromARGB(255, 64, 135, 193),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}


class CustomArrowButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const CustomArrowButton({Key? key, required this.text, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 64, 135, 193),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 10), // Space between text and arrow
            const Icon(
              Icons.arrow_forward,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

class BackArrowButton extends StatelessWidget {
  final VoidCallback onTap;

  const BackArrowButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width  * 0.02),
      child: GestureDetector(
        onTap: onTap,
        child: Icon(
          Icons.arrow_back_outlined,
          size: width * 0.07,
        ),
      ),
    );
  }
}
