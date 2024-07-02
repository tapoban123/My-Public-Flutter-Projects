import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_clone/colors.dart';
import 'package:google_clone/widgets/search.dart';
import 'package:google_clone/widgets/search_buttons.dart';
import 'package:google_clone/widgets/translation_buttons.dart';
import 'package:google_clone/widgets/web/web_footer.dart';

class WebScreen extends StatelessWidget {
  const WebScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              "Gmail",
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              "Images",
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(
              "assets/images/more-apps.svg",
              colorFilter: const ColorFilter.mode(
                primaryColor,
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0)
                .copyWith(right: 10.0),
            child: MaterialButton(
              onPressed: () {},
              color: const Color(0xff1A73EB),
              child: const Text(
                "Sign In",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 5,
          right: 5,
        ),
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.25,
            ),
            const Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Search(),
                      SizedBox(
                        height: 20,
                      ),
                      SearchButtons(),
                      SizedBox(
                        height: 20,
                      ),
                      TranslationButtons()
                    ],
                  ),
                  WebFooter()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
