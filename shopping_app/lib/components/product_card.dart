import 'package:flutter/material.dart';
 
// This page returns the product card that is displayed for each product on the first page
class ProductCard extends StatelessWidget {
  final String title;
  final String price;
  final String imagePath;
  final Color backgroundColor;

  const ProductCard({
    super.key,
    required this.title,
    required this.price,
    required this.imagePath,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    Size screenWidth = MediaQuery.sizeOf(context);

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: backgroundColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              "\$ $price",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(
              height: 5,
            ),
            // The image is returned as per the screenWidth for responsiveness.
            screenWidth.width > 650
                ? Expanded(
                    child: Image.asset(
                      imagePath,
                      height: 250,
                    ),
                  )
                : Center(
                    child: Image.asset(
                      imagePath,
                      height: 175,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
