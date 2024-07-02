import 'package:flutter/material.dart';
import 'package:google_clone/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class SearchResultsComponent extends StatefulWidget {
  final String link;
  final String text;
  final String linkToGo;
  final String description;

  const SearchResultsComponent({
    super.key,
    required this.link,
    required this.text,
    required this.linkToGo,
    required this.description,
  });

  @override
  State<SearchResultsComponent> createState() => _SearchResultsComponentState();
}

class _SearchResultsComponentState extends State<SearchResultsComponent> {
  bool _showUnderline = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.link),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            onTap: () async {
              Uri formattedUrl = Uri.parse(widget.linkToGo);
              bool urlLaunchPossible = await canLaunchUrl(formattedUrl);

              if (urlLaunchPossible) {
                await launchUrl(formattedUrl, mode: LaunchMode.inAppWebView);
              }
            },
            onHover: (hovering) {
              setState(() {
                _showUnderline = hovering;
              });
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  widget.link,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF202124),
                  ),
                ),
                Text(
                  widget.text,
                  style: TextStyle(
                    fontSize: 20,
                    color: blueColor,
                    decoration: _showUnderline
                        ? TextDecoration.underline
                        : TextDecoration.none,
                  ),
                ),
              ],
            ),
          ),
        ),
        Text(
          widget.description,
          style: const TextStyle(
            fontSize: 14,
            color: primaryColor,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
