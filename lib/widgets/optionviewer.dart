import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;

import 'package:WObs/blocs/blocs.dart';
import 'package:WObs/preferences/sharedPreferencesHelper.dart';

class SiteInfo extends Equatable {
  String site_name;
  int site_num;

  SiteInfo({
    this.site_name,
    this.site_num,
  }) : super([
          site_num,
          site_name,
        ]);
}

Future<List<SiteInfo>> InitSiteInfo() async {
  final httpClient = http.Client();
  final baseUrl = 'http://jiftp.iptime.org/wobs_sites.php';
  final Response = await httpClient.get(baseUrl);

  if (Response.statusCode != 200) {
    throw Exception('error getting weather for location');
  }

  final Json = jsonDecode(Response.body);
  final result = Json['result'];

  List<SiteInfo> siteList = List(result.length);

  for (var i = 0; i < result.length; ++i) {
    siteList[i] = new SiteInfo(
        site_name: result[i]['site_name'],
        site_num: int.parse(result[i]['site_num']));
  }

  return siteList;
}

SiteInfo getCurrentSite(List<SiteInfo> _list, int _num) {
  if (_list == null) return null;
  var list_num = _list.length;
  for (var i = 0; i < list_num; i++) {
    if (_list[i].site_num == _num) {
      return _list[i];
    }
  }
  return null;
}

class OptionViewer extends StatefulWidget {
  OptionViewer({Key key}) : super(key: key);

  @override
  _OptionViewerState createState() => _OptionViewerState();
}

class _OptionViewerState extends State<OptionViewer> {
  List<SiteInfo> site_list;
  int site_num;
  int view_num;

  @override
  void initState() {
    super.initState();

    InitSiteInfo().then((List<SiteInfo> _list) {
      setState(() {
        site_list = _list;
      });
    });

    SharedPreferencesHelper.getViewNum().then((int val) {
      setState(() {
        view_num = val;
      });
    });

    SharedPreferencesHelper.getSiteNum().then((int val) {
      setState(() {
        site_num = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final WeatherBloc _weatherBloc = BlocProvider.of<WeatherBloc>(context);

    final currentSite = getCurrentSite(site_list, site_num);

    return ListView(
        padding: const EdgeInsets.only(left: 8, right: 8),
        children: <Widget>[
          const Center(child: Text('지역 선택')),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(currentSite == null ? '' : currentSite.site_name),
              ),
              PopupMenuButton<SiteInfo>(
                initialValue: currentSite,
                icon: Icon(
                  Icons.arrow_downward,
                  color: Colors.white,
                ),
                itemBuilder: (BuildContext context) {
                  return site_list.map((SiteInfo info) {
                    return PopupMenuItem<SiteInfo>(
                      value: info,
                      child: Text(info.site_name),
                    );
                  }).toList();
                },
                onSelected: (info) async {
                  await SharedPreferencesHelper.setSIteNum(info.site_num);
                  _weatherBloc.dispatch(FetchWeather());
                  site_num = info.site_num;
                  setState(() {});
                },
                onCanceled: () async {
                  _weatherBloc.dispatch(RefreshWeather());
                  setState(() {});
                },
              ),
            ],
          ),
          const Divider(
            color: Colors.white,
          ),
          const Center(child: Text('과거 날씨 범위')),
          Slider(
            label: view_num.toString() + " 시간",
            value: view_num.toDouble(),
            onChanged: (val) {
              view_num = val.toInt();
              setState(() {});
            },
            onChangeEnd: (val) async {
              await SharedPreferencesHelper.setViewNum(val.toInt());
              _weatherBloc.dispatch(RefreshWeather());
              view_num = val.toInt();
              setState(() {});
            },
            min: 3.0,
            max: 72.0,
            divisions: 23,
            activeColor: Colors.white,
          ),
        ]);
  }
}
