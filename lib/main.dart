import 'package:flutter/material.dart';
import 'package:flutter_mvvm/mvvm/view.abs.dart';
import 'package:flutter_mvvm/routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _router = AppRouter();

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorObservers: [routeObserver],
      initialRoute: '/',
      onGenerateRoute: _router.route,
    );
  }
}
