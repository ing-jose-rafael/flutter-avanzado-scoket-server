import 'package:band_name_app/pages/home.dart';
import 'package:band_name_app/pages/status.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: 'status',
      routes: {
        'home': (_) => HomePage(),
        'status': (_) => StatusPage(),
      },
    );
  }
}
