import "dart:convert";
import 'dart:ui';
import "package:intl/intl.dart";
import 'package:flutter/material.dart';
import "package:weather_app/secrete.dart";
import "./hourl_weather_forecast_item.dart";
import "./additional_info_item.dart";
import "package:http/http.dart" as http;

class NewWeatherPage extends StatefulWidget {
  const NewWeatherPage({super.key});

  @override
  State<NewWeatherPage> createState() => _NewWeatherPageState();
}

class _NewWeatherPageState extends State<NewWeatherPage> {
  late Future<Map<String, dynamic>> fetchedWeather;
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
      return resData;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    fetchedWeather = getCurrentWeather();
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
              // print("Refresh tapped");
              fetchedWeather = getCurrentWeather();
              setState(() {});
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder(
          future: fetchedWeather,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }
            if (snapshot.hasError) {
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Center(child: Text(snapshot.error.toString())),
              );
            }
            final data = snapshot.data!;
            final currentWeatherData = data['list'][0];
            final currentTemp = currentWeatherData['main']['temp'];
            final currentSkyInfo = currentWeatherData['weather'][0]['main'];
            final currentPressure = currentWeatherData["main"]["pressure"];
            final currentWindSpeed = currentWeatherData["wind"]["speed"];
            final currentHumidity = currentWeatherData["main"]["humidity"];
            final hourlyData = data['list'];

            return Padding(
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
                                  "$currentTemp K",
                                  // "${snapshot["list"][0]["main"]["temp"]}K",
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Icon(
                                  currentSkyInfo == "Clouds"
                                      ? Icons.cloud
                                      : Icons.sunny,
                                  size: 60,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "$currentSkyInfo",
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
                    "Hourly Forecast",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      itemCount: 10,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final hourlyForecast = hourlyData[index + 1];
                        final dateTime =
                            DateTime.parse(hourlyForecast["dt_txt"].toString());
                        final time = DateFormat.Hm().format(dateTime);
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: HourlyForcastItem(
                            time: time,
                            icon: hourlyForecast["weather"][0]["main"] ==
                                        "Clouds" ||
                                    hourlyForecast["weather"][0]["main"] ==
                                        "Rain"
                                ? Icons.cloud
                                : Icons.sunny,
                            value: "${hourlyForecast["main"]['temp']} K",
                          ),
                        );
                      },
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
                        value: "$currentHumidity",
                      ),
                      AdditionalInfoPage(
                        icon: Icons.air,
                        info: "Wind Speed",
                        value: "$currentWindSpeed",
                      ),
                      AdditionalInfoPage(
                        icon: Icons.beach_access_sharp,
                        info: "Pressure",
                        value: "$currentPressure",
                      ),
                    ],
                  )
                ],
              ),
            );
          }),
    );
  }
}
