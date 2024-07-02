import 'package:beautiful_login_ui/palette.dart';
import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final Function() onPressed;
  final String buttonTitle;

  const GradientButton({
    super.key,
    required this.onPressed,
    required this.buttonTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Pallete.gradient1,
            Pallete.gradient2,
            Pallete.gradient3,
          ],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        borderRadius: BorderRadius.circular(7),
      ),
      child: ElevatedButton(
        onPressed: () => onPressed(),
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(395, 55),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
          ),
        ),
        child: Text(
          buttonTitle,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Pallete.whiteColor,
          ),
        ),
      ),
    );
  }
}
