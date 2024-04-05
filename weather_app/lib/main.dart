import 'package:flutter/material.dart';
import 'package:weather_app/pages/weather_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Weather App",
      debugShowCheckedModeBanner: false,

      // Using dark theme as default theme of the app
      theme: ThemeData.dark(useMaterial3: true),
      home: WeatherScreen(),
    );
  }
}
