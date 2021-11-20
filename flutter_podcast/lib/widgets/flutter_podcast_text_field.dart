import 'package:flutter/material.dart';

class FlutterPodcastTextField extends StatelessWidget {
  final FocusNode focusNode;
  final TextInputType keyboardType;
  final String? hintText;
  final String labelText;
  final String? errorText;
  final ValueChanged<String>? onSubmitted;
  final TextInputAction textInputAction;
  final TextEditingController controller;
  final Widget? suffixIcon;
  final bool obscureText;
  const FlutterPodcastTextField({
    Key? key,
    required this.focusNode,
    required this.textInputAction,
    required this.hintText,
    required this.labelText,
    required this.errorText,
    required this.onSubmitted,
    required this.keyboardType,
    required this.controller,
    this.obscureText = false,
    this.suffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: focusNode,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        border: const OutlineInputBorder(),
        hintText: hintText,
        labelText: labelText,
        errorText: errorText,
      ),
      onSubmitted: onSubmitted,
      textInputAction: textInputAction,
      controller: controller,
      obscureText: obscureText,
    );
  }
}
