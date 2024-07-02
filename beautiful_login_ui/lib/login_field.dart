import 'package:beautiful_login_ui/palette.dart';
import 'package:flutter/material.dart';

class LoginField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;

  const LoginField({
    super.key,
    required this.hintText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Pallete.borderColor,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Pallete.gradient2,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: const EdgeInsets.all(27),
          hintText: hintText,
        ),
      ),
    );
  }
}
