import 'dart:async';

import 'package:p_detector/utils/constants/labels.dart';
import 'package:tflite/tflite.dart';

class PlantDiseaseDector {
  static const String modelPath = "assets/plant_diseases.tflite";
  static const String labelPath = "assets/Labels.txt";
  final _completer = Completer<bool>();
  static final PlantDiseaseDector _instance = PlantDiseaseDector._internal();
  PlantDiseaseDector._internal() {
    _loadModel();
  }

  factory PlantDiseaseDector() => _instance;

  Future<String> predictImage(String path) async {
    await _completer.future;
    final res = await Tflite.runModelOnImage(
      path: path,
      numResults: 6,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    if (res != null && res.isNotEmpty) {
      return diseaseLabels[res[0]['label']] ?? "No result";
    }
    return Future.error("Failed to predict");
  }

  void _loadModel() async {
    final res = await Tflite.loadModel(
      model: modelPath,
      labels: labelPath,
      isAsset: true,
      useGpuDelegate: false,
    );
    if (res == "success") {
      _completer.complete(true);
    } else {
      _completer.completeError("Failed to load model");
    }
  }
}
