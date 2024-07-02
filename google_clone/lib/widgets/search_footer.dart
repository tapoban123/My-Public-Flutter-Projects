import 'package:flutter/material.dart';
import 'package:google_clone/colors.dart';

class SearchFooter extends StatelessWidget {
  const SearchFooter({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      children: [
        Container(
          width: double.infinity,
          color: footerColor,
          padding: EdgeInsets.symmetric(
            horizontal: size.width <= 768 ? 10 : 150.0,
            vertical: 15,
          ),
          child: Row(
            children: [
              Text(
                "India",
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 15,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Container(
                height: 20,
                width: 0.5,
                color: Colors.grey,
              ),
              const SizedBox(
                width: 10,
              ),
              const Icon(
                Icons.circle,
                color: Color(0xFF70757A),
                size: 12,
              ),
              const SizedBox(
                width: 10,
              ),
              const Text(
                "10009, Kolkata, India",
                style: TextStyle(
                  fontSize: 15,
                  color: primaryColor,
                ),
              )
            ],
          ),
        ),
        const Divider(
          thickness: 0,
          height: 9,
          color: Colors.black26,
        ),
        Container(
          color: footerColor,
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Row(
            children: [
              Text(
                "Help",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Text(
                "Send Feedback",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Text(
                "Privacy",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Text(
                "Terms",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Text(
                "Help",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
