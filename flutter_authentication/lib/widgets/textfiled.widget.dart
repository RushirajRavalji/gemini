import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String labelText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final Icon? prefixIcon;
  final TextEditingController? controller;
  final ValueChanged<String>? onChange;
  final bool? obscureText;
  final VoidCallback? showPassword;

  CustomTextField({
    required this.labelText,
    required this.keyboardType,
    required this.validator,
    this.onSaved,
    this.prefixIcon,
    this.controller,
    this.onChange,
    this.obscureText,
    this.showPassword,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final FocusNode _focusNode = FocusNode();
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _hasFocus = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 55,
      margin: const EdgeInsets.only(bottom: 15, top: 15),
      decoration: BoxDecoration(
        color: _hasFocus
            ? !isDarkMode
                ? Colors.white38
                : Colors.black
            : isDarkMode
                ? Colors.white10
                : Colors.black12,
        borderRadius: BorderRadius.circular(7.0),
        border: Border.all(
          color: _hasFocus
              ? const Color.fromARGB(255, 64, 135, 193)
              : Colors.transparent,
          width: 3.0,
        ),
      ),
      child: TextFormField(
        cursorErrorColor: Color.fromARGB(255, 64, 135, 193),
        controller: widget.controller,
        onChanged: widget.onChange,
        focusNode: _focusNode,
        keyboardType: widget.keyboardType,
        obscureText: widget.obscureText ?? false,
        cursorColor: const Color.fromARGB(255, 64, 135, 193),
        decoration: InputDecoration(
          suffixIcon: widget.labelText == "Enter Password  "
              ? IconButton(
                  onPressed: widget.showPassword,
                  icon: Icon(
                    widget.obscureText ?? false
                        ? CupertinoIcons.eye_slash_fill
                        : Icons.remove_red_eye,
                  ),
                )
              : null,
          labelText: widget.labelText,
          labelStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 17,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          filled: true,
          fillColor: Colors.transparent,
          errorStyle: TextStyle(color: Colors.transparent),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 0, color: Colors.transparent)),
          focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 0, color: Colors.transparent)),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        ),
        validator: widget.validator,
        onSaved: widget.onSaved,
      ),
    );
  }
}
