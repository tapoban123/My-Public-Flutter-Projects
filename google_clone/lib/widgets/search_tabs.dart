import 'package:flutter/material.dart';
import 'package:google_clone/widgets/search_tab.dart';

class SearchTabs extends StatelessWidget {
  const SearchTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 55,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SearchTab(
              icon: Icons.search,
              text: "All",
            ),
            SizedBox(
              width: 20,
            ),
            SearchTab(
              icon: Icons.image,
              text: "Images",
            ),
            SizedBox(
              width: 20,
            ),
            SearchTab(
              icon: Icons.map,
              text: "Maps",
            ),
            SizedBox(
              width: 20,
            ),
            SearchTab(
              icon: Icons.article,
              text: "News",
            ),
            SizedBox(
              width: 20,
            ),
            SearchTab(
              icon: Icons.shop,
              text: "Shopping",
            ),
            SizedBox(
              width: 20,
            ),
            SearchTab(
              icon: Icons.more_vert,
              text: "More",
            ),
          ],
        ),
      ),
    );
  }
}
