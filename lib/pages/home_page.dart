import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:p_detector/utils/constants/labels.dart';
import 'package:tflite/tflite.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? imageFile;
  String result = "No result";

  @override
  void initState() {
    super.initState();
    _loadTFliteModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('P-Detector'),
        elevation: 1.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                    color: imageFile == null
                        ? Colors.grey
                        : Theme.of(context).primaryColor),
              ),
              child: Text(
                result,
                style: TextStyle(
                  color: imageFile == null
                      ? Colors.grey
                      : Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0,
                ),
              ),
            ),
            const SizedBox(height: 14.0),
            if (imageFile != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.file(
                  imageFile!,
                  height: 200,
                ),
              )
            else
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: Icon(
                    Icons.photo_camera_back_outlined,
                    color: Colors.grey.shade500,
                    size: 100,
                  ),
                ),
              ),
            const SizedBox(height: 14.0),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _clearImage,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Colors.grey,
                      ),
                    ),
                    child: const Text("Clear"),
                  ),
                ),
                const SizedBox(width: 14.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _pickAndClassifyImage,
                    child: const Text("Pick Image"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _loadTFliteModel() async {
    await Tflite.loadModel(
      model: "assets/plant_diseases.tflite",
      labels: "assets/Labels.txt",
      isAsset: true,
      useGpuDelegate: false,
    );
  }

  void _predictImage() async {
    final res = await Tflite.runModelOnImage(
      path: imageFile!.path,
      numResults: 6,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    if (res == null || res.isEmpty) {
      setState(() {
        result = "No result";
      });
    } else {
      final labelKey = res[0]['label'];
      setState(() {
        result = diseaseLabels[labelKey] ?? "No result";
      });
    }
  }

  void _clearImage() {
    setState(() {
      imageFile = null;
      result = "No result";
    });
  }

  void _pickAndClassifyImage() async {
    final xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (xFile != null) {
      imageFile = File(xFile.path);
    }
    _predictImage();
  }
}
