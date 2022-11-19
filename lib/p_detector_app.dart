import 'package:flutter/material.dart';
import 'package:p_detector/pages/home_page.dart';

class PDetectorApp extends StatelessWidget {
  const PDetectorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomePage(),
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
    );
  }
}
