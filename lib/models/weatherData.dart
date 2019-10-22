import 'package:equatable/equatable.dart';

class Weather extends Equatable {
  final int site_num;
  final String site_name;

  final List<DateTime> obs_time;
  final List<String> weather_cond;
  final List<double> view_sight;
  final List<double> cloud_total;
  final List<double> air_temp;
  final List<double> dew_temp;
  final List<double> humidity;
  final List<double> surf_atm;

  Weather({
    this.site_num,
    this.site_name,
    this.obs_time,
    this.weather_cond,
    this.view_sight,
    this.cloud_total,
    this.air_temp,
    this.dew_temp,
    this.humidity,
    this.surf_atm,
  }) : super([
          site_num,
          site_name,
          obs_time,
          weather_cond,
          view_sight,
          cloud_total,
          air_temp,
          dew_temp,
          humidity,
          surf_atm,
        ]);

  static double str2num(var _input){
    if(_input == null){
     return _input;
    }
    return double.parse(_input);
  }

  static Weather fromJson(dynamic json) {
    final result = json['result'];
    final consolidatedWeather = result[0];

    int count = result.length;

    final int site_num = int.parse(consolidatedWeather['site_num']);
    final String site_name = consolidatedWeather['site_name'];
    List<DateTime> obs_time = List(count);
    List<String> weather_cond = List(count);
    List<double> view_sight = List(count);
    List<double> cloud_total = List(count);
    List<double> air_temp = List(count);
    List<double> dew_temp = List(count);
    List<double> humidity = List(count);
    List<double> surf_atm = List(count);

    for (var i = 0; i < count; i++) {
      obs_time[i] = DateTime.parse(result[i]['obs_time']);
      weather_cond[i] = result[i]['weather_cond'];
      view_sight[i] = str2num(result[i]['view_sight']);
      cloud_total[i] = str2num(result[i]['cloud_total']);
      air_temp[i] = str2num(result[i]['air_temp']);
      dew_temp[i] = str2num(result[i]['dew_temp']);
      humidity[i] = str2num(result[i]['humidity']);
      surf_atm[i] = str2num(result[i]['surf_atm']);
    }

    return Weather(
      site_num: site_num,
      site_name: site_name,
      obs_time: obs_time,
      weather_cond: weather_cond,
      view_sight: view_sight,
      cloud_total: cloud_total,
      air_temp: air_temp,
      dew_temp: dew_temp,
      humidity: humidity,
      surf_atm: surf_atm,
    );
  }
}
