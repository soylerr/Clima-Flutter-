import 'dart:convert';

import 'package:clima/screens/city_screen.dart';
import 'package:clima/services/location.dart';
import 'package:clima/services/weather.dart';
import 'package:clima/services/weather_result_by_geo.dart';
import 'package:clima/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class LocationScreen extends StatefulWidget {
  final String cityName;

  LocationScreen({Key key, @required this.cityName}) : super(key: key);
  @override
  _LocationScreenState createState() => _LocationScreenState(city: cityName);
}

class _LocationScreenState extends State<LocationScreen> {
  _LocationScreenState({this.city});
  String city = "";
  String apiKey = "f1af2d35de8f26c60f4aef52f35bfc02";
  String openWeatherUrl = "https://api.openweathermap.org/data/2.5/weather";
  final Location loc = Location();
  int celcius = 5;
  String weatherIcon = "☀";
  WeatherModel weatherModel = WeatherModel();
  String weatherMessage = "It's 🍦 time in San Francisco!";
  double kelvin = 272.15;

  @override
  void initState() {
    super.initState();
    if (city != "" || city != null) {
      print("City boş değil ve şehir bilgisi getirilecek.");
      getWeatherByCity();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    child: Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                    onPressed: () async {
                      print("Konuma göre hava durumu getiriliyor");
                      await loc.getCurrentLocation();
                      if (loc.latitude == null || loc.longitude == null) {
                        print("Lat ve lon boş geldi.");
                        return;
                      }
                      String url =
                          "$openWeatherUrl?lat=${loc.latitude}&lon=${loc.longitude}&appid=$apiKey";
                      var client = http.Client();
                      try {
                        print("url : $url");
                        Response uriResponse = await client.get(url);
                        print(uriResponse.body);
                        var jsonValue = json.decode(uriResponse.body);

                        if (jsonValue["cod"].toString() != "200") {
                          print("API sorgusu 200 değil ${jsonValue["cod"]}");
                          return;
                        }
                        WeatherResult res = WeatherResult.fromJson(jsonValue);

                        setState(() {
                          celcius = (res.main.temp - kelvin).round();
                          weatherIcon =
                              weatherModel.getWeatherIcon(res.weather[0].id);
                          weatherMessage = weatherModel.getMessage(celcius);
                          city = "";
                        });
                      } finally {
                        client.close();
                      }
                    },
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CityScreen()),
                      );
                    },
                    child: Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '$celcius°',
                      style: kTempTextStyle,
                    ),
                    Text(
                      '$weatherIcon️',
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Text(
                  "$weatherMessage",
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getWeatherByLatLon() async {}

  Future<void> getWeatherByCity() async {
    String url = "$openWeatherUrl?q=$city&appid=$apiKey";
    var client = http.Client();
    try {
      print("City url : $url");
      Response uriResponse = await client.get(url);
      print(uriResponse.body);

      var jsonValue = json.decode(uriResponse.body);
      if (jsonValue["cod"].toString() != "200") {
        print("API sorgusu 200 değil ${jsonValue["cod"]}");
        return;
      }
      WeatherResult res = WeatherResult.fromJson(jsonValue);

      setState(() {
        celcius = (res.main.temp - kelvin).round();
        weatherIcon = weatherModel.getWeatherIcon(res.weather[0].id);
        weatherMessage = weatherModel.getMessage(celcius);
      });
    } finally {
      client.close();
    }
  }
}
