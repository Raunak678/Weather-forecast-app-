import 'dart:convert';

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/secrets.dart';
import 'additional_information_item.dart';
import 'hourly_forecast_item.dart';
import 'package:http/http.dart' as http;

class WeatherSchreen extends StatefulWidget {
  const WeatherSchreen({super.key});

  @override
  State<WeatherSchreen> createState() => _WeatherSchreenState();
}

class _WeatherSchreenState extends State<WeatherSchreen> {
  @override
  void initState() {
    super.initState();
    getCurrentweather();
  }

  Future<Map<String, dynamic>> getCurrentweather() async {
    try {
      String cityName = 'London';
      final res = await http.get(Uri.parse(
        'http://api.openweathermap.org/data/2.5/forecast?q=$cityName,uk&APPID=$openWeatherApiKey',
      ));
      final data = jsonDecode(res.body);
      if (data['cod'] != '200') {
        throw 'An unexpected error occured';
      }
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: FutureBuilder(
        future: getCurrentweather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          final data = snapshot.data!;

          final currentWeatherData = data['list'][0];
          final currentTemp = currentWeatherData['main']['temp'];
          final currentSky = currentWeatherData['weather'][0]['main'];
          final currentPressure = currentWeatherData['main']['pressure'];
          final currentHumidity = currentWeatherData['main']['humidity'];
          final currentwindspee = currentWeatherData['wind']['speed'];
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Column(
                        children: [
                          BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                '$currentTemp K',
                                style: const TextStyle(
                                    fontSize: 32, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Icon(
                            currentSky == 'Clouds' || currentSky == 'Rain'
                                ? Icons.cloud
                                : Icons.sunny,
                            size: 77,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '$currentSky',
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text('Weather forecast ',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                const SizedBox(height: 15),
                /*  SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (int i = 0; i < 38; i++)
                        HourlyForecastItem(
                          time: data['list'][i + 1]['dt'].toString(),
                          icon: data['list'][i + 1]['weather'][0]['main'] ==
                                      'Clouds' ||
                                  data['list'][i + 1]['weather'][0]['main'] ==
                                      'Rain'
                              ? Icons.cloud
                              : Icons.sunny,
                          temperature:
                              data['list'][i + 1]['main']['temp'].toString(),
                        ),
                    ],
                  ),
                ),*/
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 8,
                    itemBuilder: (context, index) {
                      final hourlyForecastItem = data['list'][index + 1];
                      final hourlySky =
                          data['list'][index + 1]['weather'][0]['main'];
                      final hourlyTemp =
                          hourlyForecastItem['main']['temp'].toString();

                      final time = DateTime.parse(
                          hourlyForecastItem['dt_txt'].toString());

                      return HourlyForecastItem(
                        time: DateFormat.j().format(time),
                        icon: hourlySky == 'Clouds' || hourlySky == 'Rain'
                            ? Icons.cloud
                            : Icons.sunny,
                        temperature: hourlyTemp,
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Additional information',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Additionalinformation(
                        icon: Icons.water_drop,
                        label: 'humidity',
                        value: '$currentHumidity'),
                    Additionalinformation(
                        icon: Icons.air,
                        label: 'Windspee',
                        value: '$currentwindspee'),
                    Additionalinformation(
                        icon: Icons.beach_access,
                        label: 'Pressure',
                        value: '$currentPressure'),
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
