import 'package:flutter/material.dart';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:backdrop/backdrop.dart';

import 'package:WObs/repositories/repositories.dart';
import 'package:WObs/blocs/blocs.dart';
import 'package:WObs/preferences/sharedPreferencesHelper.dart';
import 'widgets.dart';

class MainViewer extends StatefulWidget {
  final WeatherRepository weatherRepository = WeatherRepository(
    httpClient: http.Client(),
  );

  MainViewer({Key key}) : super(key: key);

  @override
  State<MainViewer> createState() => _MainViewerState();
}

class _MainViewerState extends State<MainViewer> {
  WeatherBloc _weatherBloc;
  Completer<void> _refreshCompleter;

  @override
  void initState() {
    super.initState();

    _refreshCompleter = Completer<void>();
    _weatherBloc = WeatherBloc(weatherRepository: widget.weatherRepository);

    _weatherBloc.dispatch(
      FetchWeather(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProviderTree(
      blocProviders: [
        BlocProvider<WeatherBloc>(bloc: _weatherBloc),
      ],
      child: BackdropScaffold(
        title: Text('Weather Viewer'),
        frontLayerBorderRadius: BorderRadius.circular(0),
        iconPosition: BackdropIconPosition.none,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () async {
              _weatherBloc.dispatch(
                RefreshWeather(),
              );
              return _refreshCompleter.future;
            },
          ),
          BackdropToggleButton(
            icon: AnimatedIcons.arrow_menu,
          ),
        ],
        frontLayer: BlocBuilder(
          bloc: _weatherBloc,
          builder: (_, WeatherState state) {
            if (state is WeatherEmpty) {
              return Center(child: Text('Please Select a Location'));
            }
            if (state is WeatherLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is WeatherLoaded) {
              final weather = state.weather;
              _refreshCompleter?.complete();
              _refreshCompleter = Completer();

              return PageView(children: <Widget>[
                DataViewer(
                  weather: weather,
                ),
                ChartViewer(
                  weather: weather,
                ),
              ]);
            }
            if (state is WeatherError) {
              return Center(
                  child: Text(
                'Something went wrong!',
                style: TextStyle(color: Colors.red),
              ));
            }
          },
        ),
        backLayer: OptionViewer(),
      ),
    );
  }

  @override
  void dispose() {
    _weatherBloc.dispose();
    super.dispose();
  }
}
