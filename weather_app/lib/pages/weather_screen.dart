import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/pages/additional_info_item.dart';
import 'package:weather_app/pages/weather_forecast_item.dart';
import 'package:http/http.dart' as http;

// Declaring the main screen of the application
class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  // declaring late variable for lazy loading
  late Future<Map<String, dynamic>> weather;

  @override
  void initState() {
    super.initState();

    // late variable weather initialized
    weather = getCurrentWeather();
  }

  // Async function to call weather api and get the current weather information
  Future<Map<String, dynamic>> getCurrentWeather() async {
    await dotenv.load(fileName: '.env'); // loading the .env file

    String cityName = "Kolkata,IN";
    try {
      final APIKEY = dotenv.env[
          'WEATHER_APP_API_KEY']; // getting my OpenWeather API key from .env

      final res = await http.get(
        Uri.parse(
          "https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=${APIKEY}",
        ),
      );
      final jsonData = jsonDecode(res.body); // decode JSON data

      // if status code is not 200 then return error
      if (jsonData["cod"] != '200') {
        throw "An unexpected error occurred";
      }

      return jsonData; // if status code is 200 then return the API data
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weather App",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10.0),

            // implements the refresh button
            child: InkWell(
              onTap: () {
                setState(() {
                  weather = getCurrentWeather();
                });
              },
              borderRadius: BorderRadius.circular(50),
              child: const Icon(Icons.refresh),
            ),
          )
        ],
      ),
      body: FutureBuilder(
        future: weather,
        builder: (context, snapshot) {
          // return ProgressIndicator when the API data is loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(
                valueColor: AlwaysStoppedAnimation(Colors.white),
                // valueColor: Colors.white,
                strokeWidth: 3,
              ),
            );
          }
          // throw error when API call returns an error
          if (snapshot.hasError) {
            throw snapshot.error.toString();
          }
          // If everything is fine then execute the following
          final data = snapshot.data!;

          // Assigning all the values from the API data
          final currentData = data['list'][0];
          final temperature = currentData['main']['temp'].toString();
          final weather = currentData['weather'][0]['main'];
          final humidity = currentData['main']['humidity'].toString();
          final windSpeed = currentData['wind']['speed'].toString();
          final pressure = currentData['main']['pressure'].toString();

          // Taking only 5 time slots for the hourlyforecast
          final List<dynamic> hourlyForecastList = data['list'].sublist(1, 6);

          // finally return the body
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 10.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Temperature is displayed in Kelvin
                              Text(
                                "$temperature K",
                                style: const TextStyle(fontSize: 32.0),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              // Icon changes according to Sunny or Cloudy weather
                              Icon(
                                weather == 'Rain' || weather == 'Clouds'
                                    ? Icons.cloud
                                    : Icons.sunny,
                                // Icons.cloud,
                                size: 64,
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Text(
                                weather,
                                style: const TextStyle(fontSize: 20.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                const Text(
                  "Hourly Forecast",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                /* Using listview for lazy loading and wrapping the listview inside a SizedBox to restrict its height */
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: hourlyForecastList.length,
                    itemBuilder: (context, index) {
                      // getting the raw forecast temperature from the API call data
                      final forecastTemp =
                          hourlyForecastList[index]['main']['temp'];

                      // converting the forecast temperature to proper data format
                      final time =
                          DateTime.parse(hourlyForecastList[index]['dt_txt']);

                      // returning the HourlyForecastItem
                      return HourlyForecastItem(
                        time: DateFormat.j().format(
                            time), //  DateFormat class is from the intl package
                        itemIcon: Icons.cloud,
                        temperature: forecastTemp.toString(),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                const Text(
                  "Additional Information",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                // Returning the AdditionalInfoItem in row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInfoItem(
                        itemIcon: Icons.water_drop,
                        itemLabel: "Humidity",
                        itemMeasurement: humidity),
                    AdditionalInfoItem(
                      itemIcon: Icons.air,
                      itemLabel: "Wind Speed",
                      itemMeasurement: windSpeed,
                    ),
                    AdditionalInfoItem(
                      itemIcon: Icons.beach_access,
                      itemLabel: "Pressure",
                      itemMeasurement: pressure,
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
