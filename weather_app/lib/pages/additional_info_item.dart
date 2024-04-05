import 'package:flutter/material.dart';

// Declaring the AdditionalInfoItem class
class AdditionalInfoItem extends StatelessWidget {
  final IconData itemIcon;
  final String itemLabel;
  final String itemMeasurement;

  const AdditionalInfoItem({
    super.key,
    required this.itemIcon,
    required this.itemLabel,
    required this.itemMeasurement,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          itemIcon,
          size: 32,
        ),
        Text(
          itemLabel,
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          itemMeasurement,
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}
