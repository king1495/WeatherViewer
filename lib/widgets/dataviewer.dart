import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:WObs/models/models.dart';

class DataViewer extends StatelessWidget {
  DataViewer({Key key, @required this.weather})
      : assert(weather != null),
        super(key: key);

  final Weather weather;
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
  final double _paddingVal = 12.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.all(_paddingVal),
            child: Text(
              weather.site_name,
              textScaleFactor: 1.5,
            )),
        Padding(
          padding: EdgeInsets.all(_paddingVal),
          child: Text(
//                    _dateFormat.format(DateTime.now().toLocal()) + '\n',
            _dateFormat.format(weather.obs_time[0]) + '\n',
            textScaleFactor: 1.5,
          ),
        ),
        TableElement('현재날씨', weather.weather_cond[0], _paddingVal),
        TableElement('시정(km)', weather.view_sight[0].toString(), _paddingVal),
        TableElement('운량', weather.cloud_total[0].toString(), _paddingVal),
        TableElement('기온(℃)', weather.air_temp[0].toString(), _paddingVal),
        TableElement('이슬점(℃)', weather.dew_temp[0].toString(), _paddingVal),
        TableElement('습도(%)', weather.humidity[0].toString(), _paddingVal),
        TableElement('기압(hPa)', weather.surf_atm[0].toString(), _paddingVal),
      ],
    );
  }
}

Widget TableElement(String tag, String value, double padding) => Padding(
      padding: EdgeInsets.all(padding),
      child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(children: [
              Align(
                alignment: Alignment(1, 0),
                child: Text(
                  tag,
                ),
              ),
              Text(''),
              Align(
                alignment: Alignment(-1, 0),
                child: Text(
                  value ?? 'null',
                ),
              ),
            ]),
          ]),
    );
