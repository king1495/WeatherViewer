import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:charts_flutter/flutter.dart' as charts;

import 'package:WObs/models/models.dart';

Widget _myDataPlot(
  List<charts.Series> _seriesList,
  double ymin,
  double ymax,
  int ynum,
) {
  final _fontSize = 14;
  final _titleFontSize = 18;

  var _axisOpt;
  if (ymin != null && ymax != null) {
    final double dy = (ymax - ymin) / (ynum - 1);
    List<charts.TickSpec<double>> _yTicks = List(ynum + 1);
    for (var i = 0; i <= ynum; i++) {
      _yTicks[i] = charts.TickSpec(ymin + i * dy);
    }

    _axisOpt = charts.NumericAxisSpec(
      showAxisLine: true,
      viewport: charts.NumericExtents(ymin, ymax),
      renderSpec: charts.GridlineRendererSpec(
        axisLineStyle: charts.LineStyleSpec(
          thickness: 2,
          color: charts.MaterialPalette.white,
        ),
        lineStyle: charts.LineStyleSpec(
          thickness: 1,
          color: charts.MaterialPalette.white,
          dashPattern: [2],
        ),
        labelStyle: charts.TextStyleSpec(
            color: charts.Color.white,
            fontSize: _fontSize,
            fontFamily: 'NanumSquare'),
      ),
      tickProviderSpec: charts.StaticNumericTickProviderSpec(_yTicks),
    );
  }else{
    _axisOpt = charts.NumericAxisSpec(
      showAxisLine: true,
//      viewport: charts.NumericExtents(ymin, ymax),
      renderSpec: charts.GridlineRendererSpec(
        axisLineStyle: charts.LineStyleSpec(
          thickness: 2,
          color: charts.MaterialPalette.white,
        ),
        lineStyle: charts.LineStyleSpec(
          thickness: 1,
          color: charts.MaterialPalette.white,
          dashPattern: [2],
        ),
        labelStyle: charts.TextStyleSpec(
            color: charts.Color.white,
            fontSize: _fontSize,
            fontFamily: 'NanumSquare'),
      ),
      tickProviderSpec: charts.BasicNumericTickProviderSpec(zeroBound: false,desiredTickCount: ynum),
    );
  }

  return charts.TimeSeriesChart(
    _seriesList,
    animate: false,
//    layoutConfig: charts.LayoutConfig(leftMarginSpec: marginSpec, topMarginSpec: marginSpec, rightMarginSpec: marginSpec, bottomMarginSpec: marginSpec),
    domainAxis: charts.DateTimeAxisSpec(
      showAxisLine: true,
      tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
        hour: charts.TimeFormatterSpec(
          format: 'HH',
          transitionFormat: 'dd/HH',
        ),
      ),
      tickProviderSpec: charts.AutoDateTimeTickProviderSpec(includeTime: true),
      renderSpec: charts.GridlineRendererSpec(
        axisLineStyle: charts.LineStyleSpec(
          thickness: 2,
          color: charts.MaterialPalette.white,
        ),
        lineStyle: charts.LineStyleSpec(
          thickness: 1,
          color: charts.MaterialPalette.white,
          dashPattern: [2],
        ),
        labelStyle: charts.TextStyleSpec(
            color: charts.Color.white,
            fontSize: _fontSize,
            fontFamily: 'NanumSquare'),
      ),
    ),
    primaryMeasureAxis: _axisOpt,
    behaviors: [
      new charts.ChartTitle(
        _seriesList[0].id,
        behaviorPosition: charts.BehaviorPosition.top,
        titleOutsideJustification: charts.OutsideJustification.middleDrawArea,
        titleStyleSpec: charts.TextStyleSpec(
          color: charts.MaterialPalette.white,
          fontSize: _titleFontSize,
          fontFamily: 'NanumSquare',
        ),
        innerPadding: 16,
      ),
      new charts.LinePointHighlighter(
        showHorizontalFollowLine:
            charts.LinePointHighlighterFollowLineType.none,
        showVerticalFollowLine: charts.LinePointHighlighterFollowLineType.none,
      ),
      new charts.SelectNearest(eventTrigger: charts.SelectionTrigger.hover),
    ],
  );
}

/// Create one series with sample hard coded data.
List<List<charts.Series<TimeSeriesDatas, DateTime>>> _createSeriesList(
  Weather _weather,
) {
  List<List<charts.Series<TimeSeriesDatas, DateTime>>> data = List(4);

  List<TimeSeriesDatas> _viewdata =
      _createTimeListData(_weather.obs_time, _weather.view_sight);
  List<TimeSeriesDatas> _airdata =
      _createTimeListData(_weather.obs_time, _weather.air_temp);
  List<TimeSeriesDatas> _dewdata =
      _createTimeListData(_weather.obs_time, _weather.dew_temp);
  List<TimeSeriesDatas> _humidata =
      _createTimeListData(_weather.obs_time, _weather.humidity);
  List<TimeSeriesDatas> _clouddata =
      _createTimeListData(_weather.obs_time, _weather.cloud_total);

  data[0] = _createSeries([_viewdata], '시정(km)');
  data[1] = _createSeries([_airdata, _dewdata], '온도(℃)');
  data[2] = _createSeries([_humidata], '습도(%)');
  data[3] = _createSeries([_clouddata], '운량');

  return data;
}

/// Create one series with sample hard coded data.
List<TimeSeriesDatas> _createTimeListData(
  List<DateTime> _time,
  List<double> _value,
) {
  List<TimeSeriesDatas> data = List(_time.length);
  for (var i = 0; i < _time.length; i++) {
    data[i] = new TimeSeriesDatas(_time[i], _value[i]);
  }
  return data;
}

/// Create one series with sample hard coded data.
List<charts.Series<TimeSeriesDatas, DateTime>> _createSeries(
  List<List<TimeSeriesDatas>> _data,
  String _title,
) {
  List<charts.Series<TimeSeriesDatas, DateTime>> data = List(_data.length);
  for (var i = 0; i < _data.length; i++) {
    if (i == 0) {
      data[i] = charts.Series<TimeSeriesDatas, DateTime>(
        id: _title,
        colorFn: (TimeSeriesDatas datas, int index) =>
            charts.MaterialPalette.white,
        domainFn: (TimeSeriesDatas datas, int index) => datas.time,
        measureFn: (TimeSeriesDatas datas, int index) => datas.val,
        strokeWidthPxFn: (_, __) => 3,
        data: _data[i],
      );
    } else {
      data[i] = charts.Series<TimeSeriesDatas, DateTime>(
        id: _title + i.toString(),
        colorFn: (TimeSeriesDatas datas, int index) =>
            charts.MaterialPalette.white,
        domainFn: (TimeSeriesDatas datas, int index) => datas.time,
        measureFn: (TimeSeriesDatas datas, int index) => datas.val,
        strokeWidthPxFn: (_, __) => 3,
        dashPatternFn: (_, __) => [3],
        data: _data[i],
      );
    }
  }
  return data;
}

List<charts.TickSpec<DateTime>> _createDateTicks(List<DateTime> _d) {
  final ticknum = 6;
  final tmin = _d.last;
  final tmax = _d.first;
  final dt = tmax.difference(tmin).inHours / (ticknum - 1);

  List<charts.TickSpec<DateTime>> data = List(ticknum);
  for (var i = 0; i < ticknum; i++) {
    final val = tmin.add(Duration(hours: (i * dt).toInt()));
    data[i] = new charts.TickSpec(val, label: DateFormat('HH').format(val));
  }

  return data;
}

class ChartViewer extends StatelessWidget {
  ChartViewer({Key key, @required this.weather})
      : assert(weather != null),
        super(key: key);

  final Weather weather;
  final bool animate = false;

  @override
  Widget build(BuildContext context) {
    final List<List<charts.Series<TimeSeriesDatas, DateTime>>> seriesList =
        _createSeriesList(weather);

    return ListView.separated(
      scrollDirection: Axis.vertical,
      physics: ScrollPhysics(),
      itemBuilder: (context, position) {
        String dataType = seriesList[position][0].id;
        double ymin = 0;
        double ymax = 20;
        int ynum = 6;
        switch (dataType) {
          case '시정(km)':
            ynum = 5;
            break;
          case '온도(℃)':
            ymin = null;
            ymax = null;
//            ynum = 0;
            break;
          case '습도(%)':
            ymax = 100;
            break;
          case '운량':
            ymax = 10;
            break;
        }
        return Container(
          height: 9 * MediaQuery.of(context).size.width / 16,
          padding: EdgeInsets.only(bottom: 4, left: 4),
          child: _myDataPlot(seriesList[position], ymin, ymax, ynum),
        );
      },
      separatorBuilder: (context, position) => Divider(
            color: Colors.white,
            height: 0,
          ),
      itemCount: seriesList.length,
    );
  }
}

/// Sample linear data type.
class TimeSeriesDatas {
  final DateTime time;
  final double val;

  TimeSeriesDatas(this.time, this.val);
}
