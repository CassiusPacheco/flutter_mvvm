import 'package:app/mvvm/view.abs.dart';
import 'package:app/routes.dart';
import 'package:flutter/material.dart';

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
