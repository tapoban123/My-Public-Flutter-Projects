import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget webScreenPage;
  final Widget mobileScreenPage;
  const ResponsiveLayout({
    super.key,
    required this.webScreenPage,
    required this.mobileScreenPage,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 658) {
          return webScreenPage;
        } else {
          return mobileScreenPage;
        }
      },
    );
  }
}
