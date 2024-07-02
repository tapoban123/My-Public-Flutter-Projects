import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_clone/colors.dart';
import 'package:google_clone/widgets/search_screen.dart';

class Search extends StatelessWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Image.asset(
            "assets/images/google-logo.png",
            height: size.height * 0.12,
          ),
        ),
        const SizedBox(
          height: 20.0,
        ),
        SizedBox(
          width: size.width > 768 ? size.width * 0.4 : size.width * 0.9,
          child: TextFormField(
            onFieldSubmitted: (query) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      SearchScreen(searchQuery: query, startPageNumber: "0"),
                ),
              );
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: searchBorder),
                borderRadius: BorderRadius.circular(30.0),
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(vertical: 0.8)
                    .copyWith(left: 15),
                child: SvgPicture.asset(
                  "assets/images/search-icon.svg",
                  colorFilter: const ColorFilter.mode(
                    searchBorder,
                    BlendMode.srcIn,
                  ),
                  width: 1,
                  height: 1,
                ),
              ),
              suffixIcon: Padding(
                padding: const EdgeInsets.symmetric(vertical: 0.8)
                    .copyWith(right: 15.0),
                child: SvgPicture.asset(
                  "assets/images/mic-icon.svg",
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
