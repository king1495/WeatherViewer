import 'package:WObs/preferences/sharedPreferencesHelper.dart';
import 'package:flutter/material.dart';

import 'package:bloc/bloc.dart';

import 'package:WObs/widgets/widgets.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  onTransition(Transition transition) {
    super.onTransition(transition);
    print(transition);
  }

  @override
  void onError(Object error, StackTrace stacktrace) {
    super.onError(error, stacktrace);
    print(error);
  }
}

void main() {
//  BlocSupervisor().delegate = SimpleBlocDelegate();
  runApp(App());
}

class App extends StatelessWidget {
  App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    SharedPreferencesHelper.initPreferences();

    return MaterialApp(
      title: 'WObs',
      theme: ThemeData(
        brightness: Brightness.light,
        canvasColor: Color(0xFF99CCFF),
        primaryColor: Color(0xFF99CCFF),
        accentColor: Colors.white,
        primaryIconTheme: IconThemeData(color: Colors.white),
        primaryTextTheme: TextTheme(
          title: TextStyle(
            fontSize: 22.0,
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontFamily: 'NanumSquare',
          ),
        ),
        textTheme: TextTheme(
          body1: TextStyle(
            fontSize: 18.0,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'NanumSquare',
          ),
        ),
      ),
      home: MainViewer(),
    );
  }
}
