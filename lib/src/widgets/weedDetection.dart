import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite_v2/tflite_v2.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _isModelLoaded = false;
  bool _isProcessing = false;  // Track the processing state
  String _prediction = "";

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _loadModel();
  }

  // Initialize camera
  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _controller = CameraController(
      firstCamera,
      ResolutionPreset.high,
    );

    _initializeControllerFuture = _controller.initialize();

    // Update the state when initialization is done
    _initializeControllerFuture.then((_) {
      setState(() {});
    }).catchError((e) {
      print("Error initializing camera: $e");
    });
  }

  // Load the TFLite model
  Future<void> _loadModel() async {
    try {
      await Tflite.loadModel(
        model: 'assets/models/weed_detection_model.tflite',
        labels: 'assets/models/labels.txt',
      );
      setState(() {
        _isModelLoaded = true;
      });
    } catch (e) {
      print("Error loading model: $e");
    }
  }

  // Take screenshot, reset model, and make a prediction
  Future<void> _takeScreenshot() async {
    if (_isProcessing) return; // Prevent multiple screenshots at once

    setState(() {
      _isProcessing = true;  // Start processing
    });

    try {
      await _initializeControllerFuture;

      // Capture image
      XFile imageFile = await _controller.takePicture();

      // Run inference on the captured image only if model is available
      var output = await Tflite.runModelOnImage(
        path: imageFile.path,
        numResults: 1,
        threshold: 0.5, // Confidence threshold
        imageMean: 0.0,
        imageStd: 255.0,
      );

      // Update the label with the result
      setState(() {
        _prediction = output != null && output.isNotEmpty
            ? output[0]['label']
            : 'No result detected';
        _isProcessing = false;  // End processing
      });

      // Show prediction for 3 seconds then reset
      Future.delayed(Duration(seconds: 3), () {
        setState(() {
          _prediction = '';  // Reset the prediction
        });
      });

    } catch (e) {
      print("Error taking screenshot: $e");
      setState(() {
        _isProcessing = false;  // End processing in case of error
      });
    }
  }

  // Reset the camera and model for the next capture
  Future<void> _resetCameraAndModel() async {
    await Tflite.close();
    await _controller.dispose();

    // Reinitialize camera and model
    await _loadModel();
    await _initializeCamera();
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of camera controller
    Tflite.close();        // Close TFLite model
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Ensure the camera is initialized before trying to use it
    if (!_controller.value.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }

    bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade500,
              offset: const Offset(4, 4),
              blurRadius: 8,
              spreadRadius: 1,
            ),
            const BoxShadow(
              color: Colors.white,
              offset: Offset(-4, -4),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        width: isLandscape ? 600 : double.infinity, // Fixed width in landscape
        padding: EdgeInsets.all(16.0),
        child: Row(
          children: <Widget>[
            // 3D effect on Camera Preview (left side)
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Transform(
                transform: Matrix4.rotationX(0.1)..rotateY(0.05), // Apply 3D rotation
                alignment: Alignment.center,
                child: Container(
                  width: isLandscape ? 300 : 250,  // Fixed width for landscape mode
                  height: isLandscape ? 250 : 200, // Fixed height for landscape mode
                  decoration: BoxDecoration(
                    color: Colors.white,  // White background for the camera container
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: Offset(5, 5),
                      ),
                    ],
                  ),
                  child: CameraPreview(_controller),
                ),
              ),
            ),
            // Right part (label and screenshot button)
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(14.0),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7F7F7F), Colors.white],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        offset: const Offset(4, 4),
                        blurRadius: 4,
                      ),
                      BoxShadow(
                        color: Colors.white.withOpacity(0.2),
                        offset: const Offset(-4, -4),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Text(
                    _prediction.isEmpty
                        ? "Waiting for Prediction..."
                        : _prediction,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _takeScreenshot,
                  child: Icon(Icons.camera_alt, size: 30),  // Camera icon for screenshot button
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
                // Show loading indicator while processing
                if (_isProcessing)
                  CircularProgressIndicator(),
                // Model Loaded status indicator
                if (!_isModelLoaded)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: LinearProgressIndicator(),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}
