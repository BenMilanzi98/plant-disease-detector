import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:p_detector/p_detector_app.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );
  runApp(const PDetectorApp());
}
