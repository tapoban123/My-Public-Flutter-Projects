import 'package:flutter/material.dart';
import 'package:google_clone/colors.dart';
import 'package:google_clone/mobile/mobile_screen.dart';
import 'package:google_clone/responsive/responsive_layout.dart';
import 'package:google_clone/web/web_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Google Clone',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
      ),
      home: const ResponsiveLayout(
        webScreenPage: WebScreen(),
        mobileScreenPage: MobileScreen(),
      ),
      // home: SearchScreen(),
    );
  }
}
