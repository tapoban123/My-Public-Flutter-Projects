import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_clone/colors.dart';

class SearchHeader extends StatelessWidget {
  const SearchHeader({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    
    return Padding(
      padding: const EdgeInsets.only(
        top: 25,
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 28,
              right: 15,
              top: 4,
            ),
            child: Image.asset(
              "assets/images/google-logo.png",
              height: 30,
              width: 92,
            ),
          ),
          const SizedBox(
            width: 97,
          ),
          Container(
            width: size.width * 0.45,
            height: 44,
            decoration: BoxDecoration(
              color: searchColor,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: searchColor),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0, bottom: 12),
              child: TextFormField(
                style: const TextStyle(
                  fontSize: 16.0,
                ),
                textAlignVertical: TextAlignVertical.center,
                cursorHeight: 20,
                cursorWidth: 1,
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  focusedBorder: InputBorder.none,
                  // contentPadding: const EdgeInsets.only(bottom: 5.5),
                  enabledBorder: InputBorder.none,
                  suffixIcon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 150),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            "assets/images/mic-icon.svg",
                            height: 20,
                            width: 20,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          const Icon(
                            Icons.search,
                            color: blueColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
