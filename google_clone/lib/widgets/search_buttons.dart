import 'package:flutter/material.dart';
import 'package:google_clone/widgets/search_button.dart';

class SearchButtons extends StatelessWidget {
  const SearchButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SearchButton(
          title: "Google Search",
        ),
        SizedBox(
          width: 10,
        ),
        SearchButton(
          title: "I'm feeling lucky",
        ),
      ],
    );
  }
}
