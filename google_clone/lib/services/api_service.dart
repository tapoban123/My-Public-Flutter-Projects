import 'dart:convert';
import 'dart:developer';
import 'package:google_clone/config/dummy_api_data.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiServices {
  bool isDummyData = true;

  Future<Map<String, dynamic>> fetchData(
      {required String queryTerm, String start = "0"}) async {
            log("Reached Fetch Data");

    await dotenv.load(fileName: '.env');
    log("Fetched env");
    final APIKEY = dotenv.env['CUSTOM_SEARCH_API_KEY'];
    final CONTEXTKEY = dotenv.env['CONTEXT_KEY'];

    try {
      if (isDummyData) {
        String query = queryTerm.contains(' ')
            ? queryTerm.split(' ').join('%20')
            : queryTerm;

        final response = await http.get(
          Uri.parse(
              "https://www.googleapis.com/customsearch/v1?key=${APIKEY}&cx=${CONTEXTKEY}&q=$query&start=$start"),
        );
        if (response.statusCode == 200) {
          final jsonData = response.body;
          final responseData = json.decode(jsonData);
          log(jsonData);

          return responseData;
        }
      }
    } catch (e) {
      log(e.toString());
    }
    return dummyApiResponse;
  }
}
