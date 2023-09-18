import 'package:flutter/material.dart';
// import 'package:weather_app/my_weather_page.dart';
import 'package:weather_app/refactored_weather_page.dart';

void main() {
  runApp(const MyWeatherApp());
}

class MyWeatherApp extends StatelessWidget {
  const MyWeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: const NewWeatherPage(),
    );
  }
}
