import 'package:flutter/material.dart';

// Declaring the HourlyForecastItem class
class HourlyForecastItem extends StatelessWidget {
  final String time;
  final IconData itemIcon;
  final String temperature;

  const HourlyForecastItem({
    super.key,
    required this.time,
    required this.itemIcon,
    required this.temperature,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            Text(
              time,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            Icon(
              itemIcon,
              size: 32,
            ),
            Text(temperature)
          ],
        ),
      ),
    );
  }
}
