import 'package:beautiful_login_ui/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialButton extends StatelessWidget {
  final String iconPath;
  final String label;
  final double horizontalPadding;

  const SocialButton({
    super.key,
    required this.iconPath,
    required this.label,
    this.horizontalPadding = 100,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {},
      icon: SvgPicture.asset(
        iconPath,
        width: 25,
        colorFilter: const ColorFilter.mode(
          Pallete.whiteColor,
          BlendMode.srcIn,
        ),
      ),
      label: Text(
        label,
        style: const TextStyle(
          fontSize: 17,
          color: Pallete.whiteColor,
        ),
      ),
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: 30,
        ),
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            color: Pallete.borderColor,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
