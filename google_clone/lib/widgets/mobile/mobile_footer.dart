import 'package:flutter/material.dart';
import 'package:google_clone/widgets/footer_text.dart';

class MobileFooter extends StatelessWidget {
  const MobileFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      alignment: WrapAlignment.center,
      children: [
        FooterText(title: "About"),
        SizedBox(width: 10),
        FooterText(title: "Advertising"),
        SizedBox(width: 10),
        FooterText(title: "Business"),
        FooterText(title: "How Search Works"),
        FooterText(title: "Privacy"),
        SizedBox(width: 10),
        FooterText(title: "Terms"),
        SizedBox(width: 10),
        FooterText(title: "Settings"),
      ],
    );
  }
}
