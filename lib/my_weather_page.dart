import "dart:convert";
import 'dart:ui';
import 'package:flutter/material.dart';
import "package:weather_app/secrete.dart";
import "./hourl_weather_forecast_item.dart";
import "./additional_info_item.dart";
import "package:http/http.dart" as http;

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // double temp = 0;
  // bool isLoading = false;

  Future<Map<String, dynamic>> getCurrentWeather() async {
    String cityName = "Nigeria";
    String stateName = "lagos";
    try {
      final res = await http.get(
        Uri.parse(
            "https://api.openweathermap.org/data/2.5/forecast?q=${cityName},${stateName}&APPID=${openWeatherAPIKey}"),
      );
      final resData = jsonDecode(res.body);
      if (int.parse(resData['cod']) != 200) {
        throw resData['message'];
      }
      print("Here is the body: ${resData["list"][0]["main"]["temp"]}");
      return resData;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weather App",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 1,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              print("Refresh tapped");
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? const Center(child: CircularProgressIndicator.adaptive())
            : snapshot.hasError
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Center(child: Text(snapshot.error.toString())),
                  )
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Card(
                            elevation: 16,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(16),
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 10,
                                  sigmaY: 10,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        "${snapshot.data?["list"][0]["main"]["temp"]} K",
                                        // "${snapshot["list"][0]["main"]["temp"]}K",
                                        style: const TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Icon(
                                        snapshot.data?["list"][0]["weather"][0]
                                                    ["main"] ==
                                                "Clouds"
                                            ? Icons.cloud
                                            : Icons.sunny,
                                        size: 60,
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        "${snapshot.data?["list"][0]["weather"][0]["main"]}",
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Weather Forecast",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              HourlyForcastItem(
                                time: "09:10",
                                icon: Icons.cloud,
                                value: "300.0K",
                              ),
                              HourlyForcastItem(
                                time: "10:10",
                                icon: Icons.sunny,
                                value: "310.0K",
                              ),
                              HourlyForcastItem(
                                time: "11:10",
                                icon: Icons.sunny_snowing,
                                value: "320.0K",
                              ),
                              HourlyForcastItem(
                                time: "12:10",
                                icon: Icons.snowing,
                                value: "290.0K",
                              ),
                              HourlyForcastItem(
                                time: "12:10",
                                icon: Icons.snowing,
                                value: "290.0K",
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Additional Information",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            AdditionalInfoPage(
                              icon: Icons.water_drop,
                              info: "Humidity",
                              value:
                                  "${snapshot.data?["list"][0]["main"]["humidity"]}",
                            ),
                            AdditionalInfoPage(
                              icon: Icons.air,
                              info: "Wind Speed",
                              value:
                                  "${snapshot.data?["list"][0]["wind"]["speed"]}",
                            ),
                            AdditionalInfoPage(
                              icon: Icons.beach_access_sharp,
                              info: "Pressure",
                              value:
                                  "${snapshot.data?["list"][0]["main"]["pressure"]}",
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
      ),
    );
  }
}
