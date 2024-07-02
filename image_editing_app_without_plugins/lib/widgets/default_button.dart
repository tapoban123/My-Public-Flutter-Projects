import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final Color backgroundColor;
  final Color textColor;

  const DefaultButton({
    super.key,
    required this.onPressed,
    required this.child,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(backgroundColor),
        textStyle: WidgetStateProperty.all(
          TextStyle(
            color: textColor,
          ),
        ),
      ),
      child: child,
    );
  }
}
