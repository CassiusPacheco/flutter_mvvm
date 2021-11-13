import 'package:flutter/material.dart';
import 'package:flutter_mvvm/home/home_page.dart';
import 'package:flutter_mvvm/mvvm/view.abs.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorObservers: [routeObserver],
      home: HomePage(),
    );
  }
}
