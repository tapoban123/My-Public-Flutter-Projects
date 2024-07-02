import 'package:flutter/material.dart';
import 'package:google_clone/colors.dart';
import 'package:google_clone/services/api_service.dart';
import 'package:google_clone/widgets/search_footer.dart';
import 'package:google_clone/widgets/search_header.dart';
import 'package:google_clone/widgets/search_results_component.dart';
import 'package:google_clone/widgets/search_tabs.dart';

class SearchScreen extends StatelessWidget {
  final String searchQuery;
  final String startPageNumber;
  const SearchScreen({
    super.key,
    required this.searchQuery,
    required this.startPageNumber,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Title(
      color: blueColor,
      title: searchQuery,
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SearchHeader(),
              Padding(
                padding: EdgeInsets.only(left: size.width <= 768 ? 10 : 150.0),
                child: const SearchTabs(),
              ),
              const Divider(
                height: 0,
                thickness: 0.3,
              ),
              FutureBuilder(
                future: ApiServices().fetchData(
                  queryTerm: searchQuery,
                  start: startPageNumber,
                ),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final snapshotData = snapshot.data;

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                            left: size.width <= 768 ? 10 : 150.0,
                            top: 12,
                          ),
                          child: Text(
                            "About ${snapshotData?['searchInformation']['formattedTotalResults']} results (${snapshotData?['searchInformation']["formattedSearchTime"]}) seconds",
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color(0xff70757a),
                            ),
                          ),
                        ),
                        ListView.builder(
                          itemCount: snapshotData?['items'].length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                left: size.width <= 768 ? 10 : 150.0,
                                top: 10,
                              ),
                              child: SearchResultsComponent(
                                description: snapshotData?['items'][index]
                                    ['snippet'],
                                link: snapshotData?['items'][index]
                                    ['formattedUrl'],
                                linkToGo: snapshotData?['items'][index]['link'],
                                text: snapshotData?['items'][index]['title'],
                              ),
                            );
                          },
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () {
                                  if (startPageNumber != "0") {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => SearchScreen(
                                          searchQuery: searchQuery,
                                          startPageNumber:
                                              (int.parse(startPageNumber) - 10)
                                                  .toString(),
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: const Text(
                                  "< Prev",
                                  style: TextStyle(
                                    color: blueColor,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => SearchScreen(
                                        searchQuery: searchQuery,
                                        startPageNumber:
                                            (int.parse(startPageNumber) + 10)
                                                .toString(),
                                      ),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "Next >",
                                  style: TextStyle(
                                    color: blueColor,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        const SearchFooter(),
                      ],
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
