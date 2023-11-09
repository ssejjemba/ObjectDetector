import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cats_and_dogs/common/loading/loading_widget.dart';
import 'package:cats_and_dogs/helper/classifier.dart';
import 'package:cats_and_dogs/screens/camera/camera_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  File? _image;

  bool _isLoading = false;

  ImageClassificationHelper? imageClassificationHelper;

  Map<String, double>? classification;

  List<Widget>? classificationWidgets;

  late CameraDescription cameraDescription;

  bool cameraIsAvailable = Platform.isAndroid || Platform.isIOS;

  @override
  void initState() {
    super.initState();
    imageClassificationHelper = ImageClassificationHelper();
    imageClassificationHelper!.initHelper();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initCamera();
    });
  }

  initCamera() async {
    if (cameraIsAvailable) {
      // get list available camera
      cameraDescription = (await availableCameras()).first;
    }
  }

  Future _getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Widget _buildButton(IconData icon, String text, VoidCallback onPressed) {
    return SizedBox(
      width: 150,
      height: 140,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF141519), // Background color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Rounded corners
          ),
          padding: const EdgeInsets.all(0), // Padding
        ),
        onPressed: onPressed,
        child: Column(
          mainAxisSize: MainAxisSize.min, // To minimize the column size
          children: <Widget>[
            Icon(
              icon,
              color: Colors.white,
              size: 60,
            ), // Icon
            Text(
              text, // Text
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  _processImage() {
    if (_image == null) {
      return;
    }

    _isLoading = true;
    setState(() {});
    _detectObjectsInImage();
  }

  Future<void> _detectObjectsInImage() async {
    if (_image == null) {
      return;
    }

    final imageData = await compute(_readImageBytes, _image!);
    final image = img.decodeImage(imageData as Uint8List);
    classification = await imageClassificationHelper?.inferenceImage(image!);
    if (classification != null) {
      classificationWidgets = [
        ...(classification!.entries.toList()
              ..sort(
                (a, b) => a.value.compareTo(b.value),
              ))
            .reversed
            .take(3)
            .map(
              (e) => Container(
                padding: const EdgeInsets.all(8),
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      e.key,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Text(
                      e.value.toStringAsFixed(2),
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            )
      ];
    }
    _isLoading = false;
    debugPrint(classification.toString());
    setState(() {});
  }

  static Future<List<int>> _readImageBytes(File image) async {
    return await image.readAsBytes();
  }

  Widget _buildLoader() {
    if (!_isLoading) {
      return const SizedBox.shrink();
    }
    return const EyePhoneLoading();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const Text(
                  "Detect Object",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 24.0,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: _processImage,
                  icon: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 30,
                  ),
                )
              ],
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: Center(
                child: classificationWidgets == null
                    ? const SizedBox.shrink()
                    : classificationWidgets![0],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: _image != null
                                ? FileImage(_image!)
                                : const AssetImage(
                                        "assets/images/placeholder.png")
                                    as ImageProvider<Object>,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 2,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildButton(Icons.photo, "Gallery",
                                  () => _getImage(ImageSource.gallery)),
                              _buildButton(Icons.camera, "Camera", () {
                                if (cameraIsAvailable) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CameraScreen(
                                          camera: cameraDescription),
                                    ),
                                  );
                                }
                              }),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ]),
          _buildLoader()
        ]),
      ),
    );
  }
}
