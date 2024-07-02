import 'package:flutter/material.dart';
import 'package:image_editing_app_without_plugins/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Image Editor",
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: const HomeScreen(),
    );
  }
}
