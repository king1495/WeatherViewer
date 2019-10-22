import 'dart:convert';
import 'dart:async';

import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:WObs/models/models.dart';

//http://api.openweathermap.org/data/2.5/weather?q=seoul,KR&appid=d959bb4a109cd40d37102666ff6d9301

class WeatherRepository {
  static const baseUrl = 'http://jiftp.iptime.org/wobs_json.php';
  final http.Client httpClient;

  WeatherRepository({@required this.httpClient}) : assert(httpClient != null);

  Future<Weather> fetchWeather() async {
    final prefs = await SharedPreferences.getInstance();
    final site_num = prefs.getInt("site_num");
    final view_num = prefs.getInt("view_num") + 1;
    final weatherUrl =
        '$baseUrl?site_num=$site_num' + '&' + 'view_num=$view_num';
//    print(weatherUrl);
    final weatherResponse = await httpClient.get(weatherUrl);

    if (weatherResponse.statusCode != 200) {
      throw Exception('error getting weather for location');
    }

    final weatherJson = jsonDecode(weatherResponse.body);
//    print(weatherJson);
    return Weather.fromJson(weatherJson);
  }
}
