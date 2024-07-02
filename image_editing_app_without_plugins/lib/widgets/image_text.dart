import 'package:flutter/material.dart';
import 'package:image_editing_app_without_plugins/models/text_info.dart';

class ImageText extends StatelessWidget {
  final TextInfo textInfo;

  const ImageText({
    super.key,
    required this.textInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      textInfo.text,
      textAlign: textInfo.textAlign,
      style: TextStyle(
        fontSize: textInfo.fontSize,
        fontWeight: textInfo.fontWeight,
        fontStyle: textInfo.fontStyle,
        color: textInfo.color,
      ),
    );
  }
}
